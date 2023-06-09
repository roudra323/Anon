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
        uint256 time;
        bool downVoted;
    }

    mapping(uint256 => postInfo) public postedInfo;
    mapping(uint256 => address) private resInfo;
    mapping(uint256 => address[]) private voters;
    mapping(uint256 => uint256) private postUP;
    mapping(uint256 => uint256) private postDown;

    postInfo[] internal allPost;
    mapping(address => uint256) internal blacklistedAddress;

    /**
     * @dev Initializes the contract and sets the contract deployer as the owner.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Modifier to check if the voter has already voted on a post.
     * @param _id The ID of the post.
     * @param _addr The address of the voter.
     */
    modifier voterCheck(uint256 _id, address _addr) {
        require(postedInfo[_id].downVoted == false, "Post already removed");
        for (uint256 i = 0; i < voters[_id].length; i++) {
            if (voters[_id][i] == _addr) {
                revert("Already voted");
            }
        }
        _;
    }

    /**
     * @dev Creates a new post.
     * @param _post The content of the post.
     */
    function post(string calldata _post) public {
        require(
            blacklistedAddress[msg.sender] + 259200 <= block.timestamp,
            "You can post again after 72 hours!"
        );
        postInfo memory tempPost = postInfo(
            postID,
            _post,
            block.timestamp,
            false
        );
        resInfo[postID] = msg.sender;
        postedInfo[postID] = tempPost;
        allPost.push(tempPost);
        postID++;
    }

    /**
     * @dev Retrieves all posts.
     * @return An array of postInfo structs representing all the posts.
     */
    function viewAllPost() external view returns (postInfo[] memory) {
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

    /**
     * @dev Checks if a post should be deleted.
     * @param _id The ID of the post.
     * @return A boolean indicating whether the post should be deleted.
     */
    function shouldDelete(uint256 _id) internal view returns (bool) {
        if (postUP[_id] < postDown[_id]) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a post if it has more downvotes than upvotes in 24 hours.
     */
    function removePost() public {
        uint256 currentTime = block.timestamp;
        for (uint256 i = 0; i < allPost.length; i++) {
            if (postedInfo[i].time + 86400 <= currentTime && shouldDelete(i)) {
                postedInfo[i].downVoted = true;
                allPost[i].downVoted = true;
                blacklistedAddress[resInfo[i]] = block.timestamp;
            }
        }
    }

    /**
     * @dev Destroys the contract and transfers the remaining balance to the contract owner.
     */
    function destroyContract() external {
        require(owner == msg.sender, "Only Owner can destroy it.");
        selfdestruct(payable(owner));
    }
}
