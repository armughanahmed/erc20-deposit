pragma solidity ^0.6.0;
/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract ContextUpgradeSafe is Initializable {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.

    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {


    }


    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }

    uint256[50] private __gap;
}


/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract PausableUpgradeSafe is Initializable, ContextUpgradeSafe {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */

    function __Pausable_init() internal initializer {
        __Context_init_unchained();
        __Pausable_init_unchained();
    }

    function __Pausable_init_unchained() internal initializer {


        _paused = false;

    }


    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     */
    function _pause() public virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     */
    function _unpause() public virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }

    uint256[49] private __gap;
}

import './Token.sol';
contract ContractA is Initializable,Ownable,PausableUpgradeSafe{
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
    function deposit(address owner,uint256 _tokens) public  whenNotPaused{
        _token.approve(address(this),_tokens);
        _token.transferFrom(owner,address(this),_tokens);
        _balance[owner]=_balance[owner].safeAdd(_tokens);
        timeout=block.timestamp;
    }
    function timeOut() public view returns(uint){
        return timeout;
    }
    function withdraw(address owner) public whenNotPaused{
        require(block.timestamp>=timeout + timelimit && timeout!=0,"time not expired");
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