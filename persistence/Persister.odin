package persistence

Persister :: struct {
    save: proc(string, string),
    load: proc(string) -> string
}

persister_ctor :: proc(
    persister: ^Persister, 
    save: proc(string, string),
    load: proc(string) -> string){
        persister.save = save
        persister.load = load
}

persister_dtor :: proc (persister: ^Persister) {
    //intentially blank
}