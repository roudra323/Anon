// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Anon {
    address private owner;
    uint256 public postID;

    struct postInfo {
        string post;
        string time;
    }

    mapping(uint256 => postInfo) public postedInfo;
    mapping(uint256 => address) private resInfo;
    mapping(address => uint256) private postUP;
    mapping(address => uint256) private postDown;

    postInfo[] public allPost;

    constructor() {
        owner = msg.sender;
    }

    function post(string calldata _post, string calldata _time) public {
        postInfo memory tempPost = postInfo(_post, _time);
        resInfo[postID] = msg.sender;
        postedInfo[postID] = tempPost;
        allPost.push(tempPost);
        postID++;
    }

    function viewAllpost() external view returns (postInfo[] memory) {
        return allPost;
    }

    function upVote(uint256 _id) external {
        require(resInfo[_id] == msg.sender, "You are not alloweed to vote");
        postUP[msg.sender]++;
    }

    function downVote(uint256 _id) external {
        require(resInfo[_id] == msg.sender, "You are not alloweed to vote");
        postDown[msg.sender]++;
    }
}
