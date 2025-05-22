package raddbg_demo

import raddbg "../"

main :: proc() {

	raddbg.debug_break()
	raddbg.debug_break_if(false)

	is_attached := raddbg.is_attached() // raddbg_pin(is_attached)
	assert(is_attached)

	thread_id := raddbg.thread_id() // raddbg_pin(thread_id)
	_ = thread_id

	raddbg.thread_name("Demo - Main Thread")

	raddbg.thread_color_u32(0xff00ccff) // pink : raddbg_pin(color(0xff00ccff))
	raddbg.thread_color_rgba(1, 0.5, 0, 1) // orange
}