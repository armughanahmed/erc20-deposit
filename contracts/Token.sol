pragma solidity ^0.6.0;
import "@openzeppelin/upgrades/contracts/Initializable.sol";
// Ownable contract from open zepplin libraray

contract Ownable is Initializable{
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function initialize() public virtual initializer {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address _newOwner) public onlyOwner {
        _transferOwnership(_newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address _newOwner) internal {
        require(
            _newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, _newOwner);
        _owner = _newOwner;
    }
}


// safemath library for addition and subtraction

library SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


contract Token is Ownable{
    using SafeMath for uint256;
    string _name;
    string _symbol; 
    uint256 _totalsupply;
    uint256 _decimal;
    mapping(address=>uint256) _balance;
    mapping(address=> mapping(address=>uint256)) _allownce;
    uint x;
    function initialize() initializer override public{
        Ownable.initialize();
        _name="armughan";
        _symbol="armu";
        _decimal=0;
        _totalsupply=100*10**_decimal;
        _balance[msg.sender]=_totalsupply;
    }
    modifier ZeroAddressHell(address _add){
        require(_add != address(0),"Zero Address");
        _;
    }
    function totalsupply() public view returns(uint256){
        return _totalsupply;
    }
    function decimal() public view returns(uint256){
        return _decimal;
    }
    function balanceOf(address _tokenOwner) public view returns(uint256){
        return _balance[_tokenOwner];
    }
    function allowance(address _tokenOwner,address _spender) public view returns(uint256){
        return _allownce[_tokenOwner][_spender];
    }
    function transfer(address _to,uint256 _tokens) public returns(bool){
        transferHelper(msg.sender,_to,_tokens);
        return true;
    }
    function transferHelper(address _sender,address _receiver,uint256 _amount) public ZeroAddressHell(msg.sender){
        require(_amount<=_balance[_sender],"Not enough Balance");
        _balance[_sender]=_balance[_sender].safeSub(_amount);
        _balance[_receiver]=_balance[_receiver].safeAdd(_amount);
    }
    //     function approve(address _spender, uint256 _tokens)  external returns (bool);
    function approve(address _spender,uint256 _tokens) public returns (bool){
        ApproveHelper(msg.sender,_spender,_tokens);
        return true;
    }
    function ApproveHelper(address _sender,address _spender,uint256 _amount) public ZeroAddressHell(msg.sender){
        _allownce[_sender][_spender]=_amount;
    }
    //     function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool);
    function transferFrom(address _from,address _to,uint256 _tokens) public returns (bool){
        transferHelper(_from,_to,_tokens);
        ApproveHelper(_from,_to,_allownce[_from][_to] - _tokens);
        return true;
    }
}