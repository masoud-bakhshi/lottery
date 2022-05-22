// SPDX-License-Identifier: Masoud
pragma solidity >=0.7.5 <0.9.0;

contract Lottery{
    struct Ticket{
        uint256 id;
        uint256 createDateTime;
        address payable member;
        bool win;
    }
    
    address payable public owner;
    mapping(uint256=>Ticket) public Tickets;
    uint256 ticketPrice=100 trx;
    uint256 ticketCode=0;
    uint256 invested=0;
    uint256 public startDate;
    uint16 public day;
    
    bool isLotteryDone;
    
    event BuyTicket(address indexed addr,uint256 amount,uint256 ticketCode);
    event Winner(address indexed addr,uint256 amount,uint256 ticketCode);
    
    constructor(uint16 _day) public{
        day=_day;
        owner=  payable(msg.sender);
        startDate=block.timestamp;
    }
        // mapping(uint=>Candidate) public Candidates;
    //  Candidates[CandidateCount]=Candidate(CandidateCount,_name,0);
    function buyTicket(uint256) public payable returns(uint256 ){
        require(msg.value==ticketPrice);
        require(block.timestamp<startDate +(day*84600));
        owner.transfer(msg.value/10);
        ticketCode++;
        invested+=(msg.value*90)/100;
        Tickets[ticketCode]=Ticket(ticketCode,block.timestamp,payable(msg.sender),false);
        emit BuyTicket(msg.sender,msg.value,ticketCode);
        return ticketCode;
    }
    
    function startLottery() public{
        require(msg.sender==owner);
            require(block.timestamp>startDate +(day*84600));
            require(isLotteryDone==false);
            uint256 winnerIndex=random(ticketCode);
            Tickets[winnerIndex].win=true;
            Tickets[winnerIndex].member.transfer(invested);
            isLotteryDone=true;
            emit Winner( Tickets[winnerIndex].member,invested,winnerIndex);
    }
    
  
    function random(uint count) private view returns(uint){
      uint rand= uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty)))%count;
      return rand;
    }
    
}