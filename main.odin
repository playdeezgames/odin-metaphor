package metaphor

import "core:fmt"
import "core:encoding/uuid"


main :: proc () {
    my_uuid := uuid.generate_v4()
    fmt.println("ohai")
}