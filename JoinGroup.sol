pragma solidity >=0.4.22 <0.6.0;
contract JoinGroup {
    
      struct People {
        uint voteValue;
        uint voteNumber;
        address addr;
    }
    
    People[] proposer;
    mapping(address => uint) auditors;
    mapping(address => bool) members;
    mapping(address => bool) applyed;
    
    function init() public {
        auditors[0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C]=1;
        auditors[0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB]=2;
    }
    
      function applyJoin() public {
        if(applyed[msg.sender]!=true&&members[msg.sender]!=true&&auditors[msg.sender]==0){
            People memory p = People({voteValue:0,voteNumber:0,addr:msg.sender});
            proposer.push(p);
            applyed[msg.sender]=true;
        }
    }
     function agree(uint n) public {
        if(auditors[msg.sender]>=1){
            proposer[n].voteValue = proposer[n].voteValue|auditors[msg.sender];
            proposer[n].voteNumber=proposer[n].voteNumber+1;
            if(proposer[n].voteValue==3){
                members[proposer[n].addr]=true;
            }
        }
    }
    
    
    function isMember() public view returns(bool) {
        return members[msg.sender];
    }
    
    function getVoteNumber() public view returns(uint) {
        for(uint i=0;i<proposer.length;i++){
            if(proposer[i].addr==msg.sender){
                return proposer[i].voteNumber;
            }
        }
        return 0;
    }
}