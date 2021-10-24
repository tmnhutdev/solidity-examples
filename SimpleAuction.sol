// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract simpleAuction {
    // Variables
    address public highestBidder;
    uint public highestBid;
    uint public createdTime;
    uint public expiredTime;
    address payable public owner;
    mapping(address => uint) public pendingReturns;
    bool public isEnded = false;

    // Events
    event highestBidIncrease(address bidder, uint amount);
    event auctionEnded(address winner, uint amount);

    // Contructor
    constructor (uint _biddingTime, address payable _owner) {
        createdTime = block.timestamp;
        expiredTime = createdTime + _biddingTime;
        owner = _owner;
    }

    // Modifers
    modifier isActive {
        require(block.timestamp < expiredTime, "The auction is expired");
        _;
    }

    modifier isHighestBid(uint _amount) {
        require(_amount > highestBid, "Your bid is lower than highest bid from other");
        _;
    }

    // Functions
    function bid() public payable isActive() isHighestBid(msg.value){
        pendingReturns[highestBidder] += highestBid;
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit highestBidIncrease(msg.sender, msg.value);
    }

    function withdraw() public returns(bool) {
        uint _amount = pendingReturns[msg.sender];
        if(_amount > 0) {
            pendingReturns[msg.sender] = 0;
            if(!payable(msg.sender).send(_amount)) {
                pendingReturns[msg.sender] = _amount;
                return false;
            }
             return true;
        }
        return false;
    }

    function finishAuction() public {
        if(isEnded) {
            revert("The auction has been ended already!!!");
        }
        if(block.timestamp < expiredTime) {
            revert("The auction is still active");
        }

        isEnded = true;
        emit auctionEnded(highestBidder, highestBid);
        owner.transfer(highestBid);
    }
}