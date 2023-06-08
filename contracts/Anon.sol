// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/**
 * @title ANON
 * @dev A contract for posting and voting on content.
 */
contract ANON {
    address private owner;
    uint256 public postID;

    struct postInfo {
        uint256 id;
        string post;
        string time;
    }

    mapping(uint256 => postInfo) public postedInfo;
    mapping(uint256 => address) private resInfo;
    mapping(uint256 => address[]) private voters;
    mapping(uint256 => uint256) private postUP;
    mapping(uint256 => uint256) private postDown;

    postInfo[] internal allPost;

    /**
     * @dev Initializes the contract and sets the contract deployer as the owner.
     */
    constructor() {
        owner = msg.sender;
    }

    modifier voterCheck(uint256 _id, address _addr) {
        /**
         * @dev Modifier to check if the voter has already voted on a post.
         * @param _id The ID of the post.
         * @param _addr The address of the voter.
         */
        for (uint256 i = 0; i < voters[_id].length; i++)
            if (voters[_id][i] == _addr) {
                revert("Already voted");
            }

        _;
    }

    /**
     * @dev Creates a new post.
     * @param _post The content of the post.
     * @param _time The timestamp of the post.
     */
    function post(string calldata _post, string calldata _time) public {
        postInfo memory tempPost = postInfo(postID, _post, _time);
        resInfo[postID] = msg.sender;
        postedInfo[postID] = tempPost;
        allPost.push(tempPost);
        postID++;
    }

    /**
     * @dev Retrieves all posts.
     * @return An array of postInfo structs representing all the posts.
     */
    function viewAllpost() external view returns (postInfo[] memory) {
        return allPost;
    }

    /**
     * @dev Upvotes a post.
     * @param _id The ID of the post to upvote.
     */
    function upVote(uint256 _id) public voterCheck(_id, msg.sender) {
        require(allPost.length != 0, "No post found containing this id");
        require(resInfo[_id] != msg.sender, "Cannot upvote your own post");
        voters[_id].push(msg.sender);
        postUP[_id]++;
    }

    /**
     * @dev Downvotes a post.
     * @param _id The ID of the post to downvote.
     */
    function downVote(uint256 _id) public voterCheck(_id, msg.sender) {
        require(allPost.length != 0, "No post found containing this id");
        require(resInfo[_id] != msg.sender, "Cannot downvote your own post");
        voters[_id].push(msg.sender);
        postDown[_id]++;
    }

    function removePost() public {
        // Implementation of removePost function
    }
}
