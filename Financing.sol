pragma solidity ^0.4.10;
/**
    info: 融资智能合约
    coder: LiPeng
    date: 2019-05-27
    version: 1.0
 */
contract Financing {
    /**投资者 */ 
    struct Investor {
        address account; // 投资账户
        uint256 outAmount; // 投资的金额
    }
    /**项目 */
    struct Project {
        address recvAccount; // 收款账户
        uint256 amount; // 预计收款
        uint256 inAmount;// 统计已获得资金
        uint256 nInvectors; // 投资者个数
        mapping (uint256 => Investor) investors;
    }
    // 建立基本的属性
    uint256 nProjects = 0;
    mapping (uint256 => Project) projects;
    
    // 创建项目
    function CreateProject(address _recvAccount, uint256 _amount) public returns (uint256 pid) {
        pid = nProjects;
        uint256 inAmount = 0;
        uint256 nInvectors = 0;
        projects[pid] = Project(_recvAccount, _amount * 1000000000000000000, inAmount, nInvectors);
        nProjects++;
        return pid;
    }
    // 项目启动需要的资金总额
    function GetAmount(uint256 _pid) public constant returns (uint256 amount) {
        return projects[_pid].amount;
    }
    // 项目的投资者个数
    function GetNnInvectors(uint256 _pid) public constant returns (uint256 nInvectors) {
        return projects[_pid].nInvectors;
    }
    // 项目的已获取的投资金额
    function GetInAmount(uint256 _pid) public constant returns (uint256 inAmount) {
        return projects[_pid].inAmount;
    }
    // 判断项目是否融资成功
    function CheckItem(uint256 _pid) public constant returns (bool isSuccess) {
        uint256 amount = projects[_pid].amount;
        uint256 inAmount = projects[_pid].inAmount;
        if (0 == inAmount || inAmount < amount) {
            return false;
        } else if (inAmount >= amount) {
            return true;
        }
    }

    // 创建投资者
    function CreateInvestor() private returns (Investor) {
        return Investor(msg.sender, msg.value);
    }
    // 进行投资
    function Investing(uint256 _pid) public payable returns (bool){
        Investor memory investor = CreateInvestor();
        Project storage project = projects[_pid];
        require (msg.value <= msg.sender.balance);
        project.recvAccount.transfer(msg.value);
        // 数据结构属性计算
        project.inAmount += msg.value;
        project.investors[project.nInvectors] = investor;
        project.nInvectors++;
        return true;
    }
}