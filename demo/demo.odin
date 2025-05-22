package raddbg_demo

import "core:sync"
import "core:thread"

import raddbg "../"

worker_thread_id : int
worker_thread_id_event : sync.One_Shot_Event
worker_thread_stop : bool

main :: proc() {

	raddbg.debug_break()
	raddbg.debug_break_if(false)

	is_attached := raddbg.is_attached() // raddbg_pin(is_attached)
	assert(is_attached)

	thread_id := raddbg.thread_id() // raddbg_pin(thread_id)
	_ = thread_id

	// Set thread info for the current thread
	raddbg.thread_name("Demo - Main Thread")
	raddbg.thread_color_u32(0xff00ccff) // pink : raddbg_pin(color(0xff00ccff))
	raddbg.thread_color_rgba(1, 0.5, 0, 1) // orange

	// Create a worker thread and save it's thread id
	worker_thread := thread.create_and_start(proc() {
		worker_thread_id = raddbg.thread_id()
		sync.one_shot_event_signal(&worker_thread_id_event)

		for !sync.atomic_load(&worker_thread_stop) {
		}
	})

	sync.one_shot_event_wait(&worker_thread_id_event)

	// Set thread info for other threads
	raddbg.thread_id_name(worker_thread_id, "Demo - Worker Thread")
	raddbg.thread_id_color_u32(worker_thread_id, 0xff00ccff) // pink
	raddbg.thread_id_color_rgba(worker_thread_id, 1, 0.5, 0, 1) // orange

	sync.atomic_store(&worker_thread_stop, true)
	thread.join(worker_thread)
}