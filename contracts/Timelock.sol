pragma solidity 0.4.24;

interface IERC20 {
    function transfer(address _to, uint256 _value) external returns (bool success);
    function balanceOf(address _owner) external view returns (uint256 balance);
}

library SafeERC20 {
  function safeTransfer(IERC20 _token, address _to, uint256 _value) internal {
    require(_token.transfer(_to, _value));
  }
}

contract Timelock {
    using SafeERC20 for IERC20;
    IERC20 public token;
    address public beneficiary;
    uint256 public releaseTime;

    event TokenReleased(address beneficiary, uint256 amount);

    constructor(
        IERC20 _token,
        address _beneficiary,
        uint256 _releaseTime
    ) public {
        require(_releaseTime > now);
        require(_beneficiary != 0x0);
        token = _token;
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
    }

    function release() public returns(bool success) {
        require(now >= releaseTime);
        uint256 amount = token.balanceOf(address(this));
        require(amount > 0);
        token.safeTransfer(beneficiary, amount);
        emit TokenReleased(beneficiary, amount);
        return true;
    }
}
