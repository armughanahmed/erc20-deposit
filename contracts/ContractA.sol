pragma solidity ^0.6.0;
import './Token.sol';
contract ContractA is Initializable,Ownable{
    using SafeMath for uint256;
    Token public _token;
    mapping(address=>uint256) _balance;
    uint timeout;
    uint timelimit;
    function initialize(Token addr) public initializer{
        _token=addr;
    }
    function setAddress(Token addr) public{
        _token=addr;
    }
    function deposit(address owner,uint256 _tokens) public {
        _token.approve(address(this),_tokens);
        _token.transferFrom(owner,address(this),_tokens);
        _balance[owner]=_balance[owner].safeAdd(_tokens);
        timeout=block.timestamp;
    }
    function timeOut() public view returns(uint){
        return timeout;
    }
    function withdraw(address owner) public {
        require(block.timestamp>=timeout + timelimit,"time not expired");
        _token.transferFrom(address(this),owner,_balance[owner]);
        _balance[owner]=_balance[owner].safeSub(getBalance1(owner));
    }
    function getBalance(address owner) public view returns(uint256){
        return _token.balanceOf(owner);
    }
    function getBalance1(address owner) public view returns(uint256){
        return _balance[owner];
    }
    function getAddress() public view returns(address){
        return address(this);
    }
    function getTokenAddress() public view returns(address){
        return address(_token);
    }
    function getCurrentTime() public view returns(uint){
        return block.timestamp;
    }
    function updateTime(uint secs) public onlyOwner returns(uint){
        timelimit=secs;
    }
}