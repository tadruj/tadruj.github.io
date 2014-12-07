interface Person {
    firstname: string
    lastname: string
}

class Student implements Person {
    fullname: string;
    constructor(public firstname, public lastname) {
        this.fullname = this.firstname + " " + this.lastname
    }
}

function greeter(person: Student) {
    return "Hello, " + person.fullname;
}

var user = new Student("Rok", "Krulec");

console.log(greeter(user));

