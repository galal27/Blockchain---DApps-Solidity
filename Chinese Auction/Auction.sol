pragma solidity ^0.4.17;
contract Auction {

    // Data structure to hold details of the item
    struct Item {
        uint itemId; // id of the item
        uint[] itemTokens;  //tokens bid in favor of the item

    }

   //Structure to hold the details of a persons
    struct Person {
        uint remainingTokens; // tokens remaining with bidder
        uint personId; // it serves as tokenId as well
        address addr;//address of the bidder
    }

    mapping(address => Person) tokenDetails; //address to person
    Person[4] bidders;//Array containing 4 person objects

    Item[3] public items;//Array containing 3 item objects
    address[3] public winners;//Array for address of winners
    address public beneficiary;//owner of the smart contract

    uint bidderCount=0;//counter

    //functions

    function Auction() public payable{    //constructor

        //Initializing beneficiary with address of smart contract owner
        beneficiary = msg.sender;

        uint[] memory emptyArray;
        items[0] = Item({itemId:0,itemTokens:emptyArray});

        //Initializing auction items
        items[1] = Item({itemId:1,itemTokens:emptyArray});
        items[2] = Item({itemId:2,itemTokens:emptyArray});
    }


    function register() public payable{


        bidders[bidderCount].personId = bidderCount;

        //Initializing the address of the bidder
        bidders[bidderCount].addr = msg.sender;

        bidders[bidderCount].remainingTokens = 5; // only 5 tokens
        tokenDetails[msg.sender] = bidders[bidderCount];
        bidderCount++;
    }

    function bid(uint _itemId, uint _count) public payable{
        /*If the number of tokens remaining with the bidder is < count of tokens bidded, revert.
          If there are no tokens remaining with the bidder, revert.
          If the id of the item for which bid is placed, is greater than 2, revert.
        */
        if ((tokenDetails[msg.sender].remainingTokens < _count) ||
        (tokenDetails[msg.sender].remainingTokens == 0 ) ||
        (_itemId > 2)) revert();

        //Decrement the remainingTokens by the number of tokens bid
        //Store the value in balance variable
        uint balance = tokenDetails[msg.sender].remainingTokens - _count;

        tokenDetails[msg.sender].remainingTokens = balance;

        //updating the same balance in bidders map
        bidders[tokenDetails[msg.sender].personId].remainingTokens = balance;

        Item storage bidItem = items[_itemId];
        for(uint i = 0; i<_count;i++) {
            bidItem.itemTokens.push(tokenDetails[msg.sender].personId);
        }
    }

    //Modifier to ensure that only owner is allowed to reveal winners
    modifier onlyOwner {
        require(msg.sender == beneficiary);
        _;
    }


    function revealWinners() public onlyOwner{

        //Iterate over all the items present in the auction
        //If at least one person has placed bid, randomly select the winner

        for (uint id = 0; id < 3; id++) {
            Item storage currentItem = items[id];
            if(currentItem.itemTokens.length != 0){
            // generate random# from block number
            uint randomIndex = (block.number / currentItem.itemTokens.length)% currentItem.itemTokens.length;
            
            // Obtain the winning tokenId
            uint winnerId = currentItem.itemTokens[randomIndex];

            //Assign winners
            winners[id] = bidders[winnerId].addr;

            }
        }
    }

}