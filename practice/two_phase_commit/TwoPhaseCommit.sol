// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// 错误码
error TwoPhaseCommit__DataKeyIsNull();
error TwoPhaseCommit__DataValueIsNull();
error TwoPhaseCommit__DataIsNotExist();
error TwoPhaseCommit__DataIsLocked();
error TwoPhaseCommit__DataIsNotLocked();
error TwoPhaseCommit__DataIsInconsistent();

/**
 * @title TwoPhaseCommit 合约
 * @author Yu ZHANG
 * @dev 两阶段提交方法
 * 1. set: 两阶段 - 预提交
 * 2. commit: 两阶段 - 正式提交
 * 3. rollback: 两阶段 - 回滚
 * 4. get: 获取数据
 * @dev 辅助方法
 * 1. isValidKey: 检查key是否合法
 * 2. isValidValue: 检查value是否合法
 * 3. isEqualString: 比较两个字符串是否相等
 */
contract TwoPhaseCommit {
    // 类型定义
    enum State {
        UNLOCKED,
        LOCKED
    }

    struct Payload {
        State state;
        string value;
        string lockValue;
    }

    // 状态变量
    mapping (string => string) private store;
    mapping (string => Payload) keyToPayload;
    string private constant HEALTH_STATUS = "success";

    // 事件
    event setEvent(string indexed key, string indexed value);
    event getEvent(string indexed key, string indexed value);
    event commitEvent(string indexed key, string indexed value);
    event rollbackEvent(string indexed key, string indexed value);

    /**
     * @notice 两阶段 - 预提交
     * @param _key 数据 - 键
     * @param _value 数据 - 值
     */
    function set(string memory _key, string memory _value) public
    {
        if (!isValidKey(bytes(_key))) {
            revert TwoPhaseCommit__DataKeyIsNull();
        }

        if (!isValidValue(bytes(_value))) {
            revert TwoPhaseCommit__DataValueIsNull();
        }

        if (keyToPayload[_key].state == State.LOCKED) {
            revert TwoPhaseCommit__DataIsLocked();
        }

        keyToPayload[_key].state = State.LOCKED;
        keyToPayload[_key].lockValue = _value;
        emit setEvent(_key, _value);
    }

    /**
     * @notice 两阶段 - 正式提交
     * @param _key 数据 - 键
     * @param _value 数据 - 值
     */
    function commit(string memory _key, string memory _value) public
    {
        if (!isValidKey(bytes(_key))) {
            revert TwoPhaseCommit__DataKeyIsNull();
        }

        if (!isValidValue(bytes(_value))) {
            revert TwoPhaseCommit__DataValueIsNull();
        }

        if (keyToPayload[_key].state == State.UNLOCKED) {
            revert TwoPhaseCommit__DataIsNotLocked();
        }

        if (!isEqualString(keyToPayload[_key].lockValue, _value)) {
            revert TwoPhaseCommit__DataIsInconsistent();
        }
        store[_key] = _value;
        keyToPayload[_key].state = State.UNLOCKED;
        keyToPayload[_key].value = _value;
        keyToPayload[_key].lockValue = "";
        emit commitEvent(_key, _value);
    }

    /**
     * @notice 两阶段 - 回滚
     * @param _key 数据 - 键
     * @param _value 数据 - 值
     */
    function rollback(string memory _key, string memory _value) public
    {
        if (!isValidKey(bytes(_key))) {
            revert TwoPhaseCommit__DataKeyIsNull();
        }

        if (!isValidValue(bytes(_value))) {
            revert TwoPhaseCommit__DataValueIsNull();
        }

        if (keyToPayload[_key].state == State.UNLOCKED) {
            revert TwoPhaseCommit__DataIsNotLocked();
        }

        if (!isEqualString(keyToPayload[_key].lockValue, _value)) {
            revert TwoPhaseCommit__DataIsInconsistent();
        }
        keyToPayload[_key].state = State.UNLOCKED;
        keyToPayload[_key].lockValue = "";
        emit rollbackEvent(_key, _value);
    }

    /**
     * @notice 获取数据
     * @param _key 数据 - 键
     */
    function get(string memory _key) public returns (string memory)
    {
        if (!isValidKey(bytes(_key))) {
            revert TwoPhaseCommit__DataKeyIsNull();
        }

        if (!isValidValue(bytes(store[_key]))) {
            revert TwoPhaseCommit__DataIsNotExist();
        }

        emit getEvent(_key, store[_key]);
        return store[_key];
    }

    /**
     * @notice 数据键格式校验
     * @param _key 数据 - 键
     */
    function isValidKey(bytes memory _key) private pure returns (bool) 
    {
        bytes memory key = _key;

        if (key.length == 0) {
            return false;
        }
        return true;
    }

    /**
     * @notice 数据值格式校验
     * @param _value 数据 - 值
     */
    function isValidValue(bytes memory _value) private pure returns (bool) 
    {
        bytes memory value = _value;

        if (value.length == 0) {
            return false;
        }
        return true;
    }

    /**
     * @notice 判断字符串是否相等
     * @param _str1 字符串1
     * @param _str2 字符串2
     */
    function isEqualString(string memory _str1, string memory _str2) private pure returns (bool) {
        return keccak256(abi.encode(_str1)) == keccak256(abi.encode(_str2));
    }
}