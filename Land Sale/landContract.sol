pragma solidity ^0.5.0;

contract LandContract {
    address payable owner;
    mapping (address => uint) public balances;
    
    struct Plot {
        address owner;
        bool forSale;
        uint price;
    }
    
    Plot[12] public plots;
    
    event PlotOwnerChanged(uint index);
    
    event PlotPriceChanged(uint index, uint price);
    
    event PlotAvailabilityChanged(uint index, uint price, bool forSale);
    
    constructor() public {
        owner = msg.sender;
        for (uint p = 0; p < 12; p++) {
            plots[p].price = 4000;
            plots[p].forSale = true;
        }
    }
    
    function putPlotUpForSale(uint index, uint price) public {
        Plot storage plot = plots[index];
        
        require(msg.sender == plot.owner && price > 0);
        
        plot.forSale = true;
        plot.price = price;
        emit PlotAvailabilityChanged(index, price, true);
    }
    
    function takeOffMarket(uint index) public {
        Plot storage plot = plots[index];
        
        require(msg.sender == plot.owner);
        
        plot.forSale = false;
        emit PlotAvailabilityChanged(index, plot.price, false);
    }
    
    function getPlots() public view returns(address[] memory, bool[] memory, uint[] memory) {
        address[] memory addrs = new address[](12);
        bool[] memory available = new bool[](12);
        uint[] memory price = new uint[](12);
        
        for (uint i = 0; i < 12; i++) {
            Plot storage plot = plots[i];
            addrs[i] = plot.owner;
            price[i] = plot.price;
            available[i] = plot.forSale;
        }
        
        return (addrs, available, price);
    }
    
    function buyPlot(uint index) public payable {
        Plot storage plot = plots[index];
        
        require(msg.sender != plot.owner && plot.forSale && msg.value >= plot.price);
        
        if(plot.owner == address(0x0)) {
            balances[owner] += msg.value;
        }else {
            balances[plot.owner] += msg.value;
        }
        
        plot.owner = msg.sender;
        plot.forSale = false;
        
        emit PlotOwnerChanged(index);
    }
    
    function withdrawFunds() public {
        address payable payee = msg.sender;
          uint payment = balances[payee];
    
          require(payment > 0);
    
          balances[payee] = 0;
          require(payee.send(payment));
    }
    
    
    function destroy() payable public {
        require(msg.sender == owner);
        selfdestruct(owner);
    }
}

