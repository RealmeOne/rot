pragma solidity ^0.4.24;

interface ROT {
    function transfer(address _to, uint256 _value) external returns (bool success);
    function balanceOf(address _owner) external view returns (uint256 balance);
}

contract Timelock {
    ROT public token;
    address public beneficiary;
    uint256 public releaseTime;

    event TokenReleased(address beneficiary, uint256 amount);

    constructor(
        address _token,
        address _beneficiary,
        uint256 _releaseTime
    ) public {
        require(_releaseTime > now);
        require(_beneficiary != address(0));
        token = ROT(_token);
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
    }

    function release() public {
        require(now >= releaseTime);
        uint256 amount = token.balanceOf(address(this));
        require(amount > 0);
        token.transfer(beneficiary, amount);
        emit TokenReleased(beneficiary, amount);
    }
}
