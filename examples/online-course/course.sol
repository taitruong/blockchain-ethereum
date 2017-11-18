pragma solidity ^0.4.6;

/*
* Source: https://www.ethereum.org/token
*/
contract owned {
    address public owner;

    function owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }

    function kill() {
        if (msg.sender == owner) selfdestruct(owner);
    }
}

contract CourseMgmt is owned {

    struct Course {
    string name;
    uint8 fee;
    }

    Course[] courses;
    string[] public courseNames;

    function CourseMgmt() {

    }

    function create(string _name, uint8 _fee) {
        courses.push(Course ({
        name: _name,
        fee: _fee
        }));
        courseNames.push(_name);
        Create(msg.sender, _name, _fee);
    }

    function courseExists(string _courseName) returns (bool) {
        for (uint i=0; i < courses.length; i++) {
            if (keccak256(courses[i].name) == keccak256(_courseName)) {
                CourseExist(msg.sender, _courseName, true);
                return true;
            }
        }
        CourseExist(msg.sender, _courseName, false);
        return false;
    }

    function _findCourse(string _courseName) internal returns (Course course) {
        for (uint i=0; i < courses.length; i++) {
            if (keccak256(courses[i].name) == keccak256(_courseName)) {
                course = courses[i];
            }
        }
        return course;
    }

    function listCourseFee(string _courseName) public returns (uint) {
        Course memory course = _findCourse(_courseName);
        ListCourseFee(msg.sender, _courseName, course.fee);
        return course.fee;
    }

    function deleteCourse(string _courseName) returns (bool) {
        for (uint i=0; i < courses.length; i++) {
            if (keccak256(courseNames[i]) == keccak256(_courseName)) {
                delete courses[i];
                delete courseNames[i];
                Success(msg.sender, true);
                return true;
            }
        }
        Success(msg.sender, false);
        return false;
    }

    event Create(address from, string _courseName, uint8 _fee);
    event ListCourseFee(address from, string _courseName, uint8 _fee);
    event CourseExist(address from, string _courseName, bool _exists);
    event Success(address from, bool _exists);

}
