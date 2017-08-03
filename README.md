# FireBase-Auth-AmanGarry


ExecutableTestCode.swift is having code to test, have to add Firebase Project Id and Token to test.

TO DO:

1. Save Expiration time of token in storage and retieve that, so that each instance of middleware can use that, Currently middleware fetchPublicKeys funcation is making HTTP request each time a new instance of middleware is called.


### How to use :-
1.  add this line to your Package.json (dependencies) :

.Package(url: "https://github.com/Aman-US-Punjabi/FireBase-Auth-AmanGarry.git", Version(0,2,2))

2. Congifure the provider in your Config+Setup.swift file :
/// Configure providers
private func setupProviders() throws {
    try addProvider(FirebaseAuthAmanGarry.Provider.self)
}

3. Add the middleware to your routes

//-------------------  API  ----------------------
let api = grouped("api")

//-------------------  API-V1  -------------------
let v1 = api.grouped("v1")

let demo = FirebaseAuthMiddleware(with: self.firebaseProjectId!)

let secureDemo = v1.grouped(demo)

secureDemo.get("hello") { req in
    var json = JSON()
    try json.set("hello", "world")
    return json
}
