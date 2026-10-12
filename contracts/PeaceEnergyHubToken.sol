// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PeaceEnergyHubToken ($PEHT)
 * @dev Token for financing and governing peaceful energy hubs, featuring an emergency Kill-Switch for active conflict.
 */
contract PeaceEnergyHubToken {
    string public name = "Peace Energy Hub Token";
    string public symbol = "PEHT";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000000000 * 10**18;

    bool public isPeaceActive = true;
    address public owner;
    address public securityOracle;

    mapping(address => uint256) public balanceOf;

    event PeaceStatusChanged(bool indexed newStatus);
    event DividendsDistributed(uint256 amount);

    modifier onlyOracleOrOwner() {
        require(msg.sender == securityOracle || msg.sender == owner, "PEHT: Not authorized");
        _;
    }

    constructor(address _securityOracle) {
        owner = msg.sender;
        securityOracle = _securityOracle;
        balanceOf[msg.sender] = totalSupply;
    }

    function setPeaceStatus(bool _status) external onlyOracleOrOwner {
        isPeaceActive = _status;
        emit PeaceStatusChanged(_status);
    }

    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(isPeaceActive, "PEHT: EMERGENCY LOCK - Transfers blocked due to active conflict or war.");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        return true;
    }
}
