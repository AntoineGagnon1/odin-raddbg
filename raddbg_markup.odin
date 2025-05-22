package raddbg

import "core:c"
import "core:fmt"

when ODIN_OS == .Windows {
	foreign import raddbg "raddbg.lib"
} else {
	#assert(false, "OS not supported")
}

is_attached :: proc "contextless" () -> bool {
	return bool(raddbg_is_attached__impl())
}

thread_id :: proc "contextless" () -> int {
	return int(raddbg_thread_id__impl())
}

thread_name :: proc(format : string, args : ..any, allocator := context.allocator) {
	str := fmt.caprintf(format, ..args, allocator = allocator)
	raddbg_thread_name__impl(raddbg_thread_id__impl(), str)
	delete(str)
}

thread_id_name :: proc(id : int, format : string, args : ..any, allocator := context.allocator) {
	str := fmt.caprintf(format, ..args, allocator = allocator)
	raddbg_thread_name__impl(c.int(id), str)
	delete(str)
}

thread_color_u32 :: proc "contextless" (hexcode : u32) {
	raddbg_thread_color__impl(raddbg_thread_id__impl(), c.uint(hexcode))
}

thread_color_rgba :: proc "contextless" (r, g, b, a : f32) {
	raddbg_thread_color__impl(raddbg_thread_id__impl(), (c.uint(r*255) << 24) | (c.uint(g*255) << 16) | (c.uint(b*255) << 8) | c.uint(a*255))
}

thread_id_color_u32 :: proc "contextless" (id : int, hexcode : u32) {
	raddbg_thread_color__impl(c.int(id), c.uint(hexcode))
}

thread_id_color_rgba :: proc "contextless" (id : int, r, g, b, a : f32) {
	raddbg_thread_color__impl(c.int(id), (c.uint(r*255) << 24) | (c.uint(g*255) << 16) | (c.uint(b*255) << 8) | c.uint(a*255))
}

// Renamed from raddbg_break because break is a keyword
debug_break :: proc "contextless" () {
	raddbg_break__impl()
}

debug_break_if :: proc "contextless" (cond : bool) {
	if cond {
		raddbg_break__impl()
	}
}

watch :: proc(format : string, args : ..any, allocator := context.allocator) {
	str := fmt.caprintf(format, ..args, allocator = allocator)
	raddbg_watch__impl(str)
	delete(str)
}

log :: proc(msg : cstring) {
	assert(len(msg) <= 4096) // the buffer in raddbg_log__impl is 4096 chars
	raddbg_log__impl(msg)
}

// raddbg_pin(expr) in a comment to create a watch pin

@(default_calling_convention="c")
foreign raddbg {
	raddbg_is_attached__impl :: proc() -> c.int ---
	raddbg_thread_id__impl :: proc() -> c.int ---
	raddbg_thread_name__impl :: proc(id : c.int, fmt : cstring, #c_vararg args : ..any) ---
	raddbg_thread_color__impl :: proc(id : c.int, hexcode : c.uint) ---
	raddbg_break__impl :: proc() ---
	raddbg_watch__impl :: proc(fmt : cstring, #c_vararg args : ..any) ---
	raddbg_log__impl :: proc(fmt : cstring, #c_vararg args : ..any) ---
	raddbg_add_or_remove_breakpoint__impl :: proc(ptr : rawptr, set, size, r, w, x : c.int) ---
}