var Student = (function () {
    function Student(firstname, lastname) {
        this.firstname = firstname;
        this.lastname = lastname;
        this.fullname = this.firstname + " " + this.lastname;
    }
    return Student;
})();
function greeter(person) {
    return "Hello, " + person.fullname;
}
var user = new Student("Rok", "Krulec");
console.log(greeter(user));
