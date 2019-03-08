pragma solidity ^0.5.0;

import "installed_contracts/oraclize-api/contracts/usingOraclize.sol";

contract Casino is usingOraclize {
   address owner;

   uint public minimumBet = 100 finney; // Equal to 0.1 ether

   // Total Ether bet for this current game
   uint public totalBet;

   // Number of total bets by users
   uint public numberOfBets;

   // Max amount of bets that can be made for each game
   uint public maxAmountOfBets = 10;

   // Limiting max bets to limit gas consumptuon when distributing prizes
   uint public constant LIMIT_AMOUNT_BETS = 100;

   // Winning number from last hame
   uint public numberWinner;

   address[] public players;

   // Mapping of number to players that bet on it
   mapping(uint => address payable[]) numberBetPlayers;

   // Mapping of players and the number they bet for
   mapping(address => uint) playerBetsNumber;

   // Only execute functions when bets are completed
   modifier onEndGame(){
      if(numberOfBets >= maxAmountOfBets) _;
   }

    constructor (uint _minimumBet, uint _maxAmountOfBets) public {
      owner = msg.sender;
      
      if(_minimumBet > 0) minimumBet = _minimumBet;
      if(_maxAmountOfBets > 0 && _maxAmountOfBets <= LIMIT_AMOUNT_BETS)
         maxAmountOfBets = _maxAmountOfBets;

      // Set the proof of oraclize in order to make secure random number generations
      oraclize_setProof(proofType_Ledger);
   }

   function checkPlayerExists(address player) public view returns(bool){
      if(playerBetsNumber[player] > 0)
         return true;
      else
         return false;
   }

   function bet(uint numberToBet) public payable{

      // Check that we haven't reached max bets
      assert(numberOfBets < maxAmountOfBets);

      // Check that this is a new player
      assert(checkPlayerExists(msg.sender) == false);

      // Check that the number to bet is within the range
      assert(numberToBet >= 1 && numberToBet <= 10);

      // Check that the amount paid is bigger or equal the minimum bet
      assert(msg.value >= minimumBet);

      // Set the number bet for that player
      playerBetsNumber[msg.sender] = numberToBet;

      // The player msg.sender has bet for that number
      numberBetPlayers[numberToBet].push(msg.sender);

      numberOfBets += 1;
      totalBet += msg.value;

      if(numberOfBets >= maxAmountOfBets) generateNumberWinner();
   }

   // Payable oraclize function to generate the winning random number
   function generateNumberWinner() public payable onEndGame {
      uint numberRandomBytes = 7;
      uint delay = 0;
      uint callbackGas = 200000;

      bytes32 queryId = oraclize_newRandomDSQuery(delay, numberRandomBytes, callbackGas);
   }

   /// @notice Callback function that gets called by oraclize when the random number is generated
   /// @param _queryId The query id that was generated to proofVerify
   /// @param _result String that contains the number generated
   /// @param _proof A string with a proof code to verify the authenticity of the number generation
   function __callback (
      bytes32 _queryId,
      string memory _result,
      bytes memory _proof
   ) oraclize_randomDS_proofVerify(_queryId, _result, _proof) public onEndGame {

      // Check that sender is oraclize
      assert(msg.sender == oraclize_cbAddress());

      numberWinner = (uint(keccak256(abi.encodePacked(_result)))%10+1);
      distributePrizes();
   }

   // Pay out the winners, clear player list and reset 'totalBet' and 'numberOfBets'
   function distributePrizes() public onEndGame {
      uint winnerEtherAmount = totalBet / numberBetPlayers[numberWinner].length; // How much each winner gets

      // Loop through all the winners to send the corresponding prize for each one
      for(uint i = 0; i < numberBetPlayers[numberWinner].length; i++){
         numberBetPlayers[numberWinner][i].transfer(winnerEtherAmount);
      }

      // Delete all the players for each number
      for(uint j = 1; j <= 10; j++){
         numberBetPlayers[j].length = 0;
      }

      totalBet = 0;
      numberOfBets = 0;
   }
}
