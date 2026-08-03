// See 'callback-usage.txt' in this directory for instructions on how to use this.
// It used to be in this file, but Travis no likey.

/datum/callback
	var/datum/object = GLOBAL_PROC
	var/delegate
	var/list/arguments

/datum/callback/New(thingtocall, proctocall, ...)
	if (thingtocall)
		object = thingtocall
	delegate = proctocall
	//Store object proc references by name: BYOND 515+ made call(Object, ProcPath)() invoke that
	//exact proc, skipping subtype overrides. call(Object, "ProcName")() still resolves them.
	//Global proc paths are kept intact - call(Path)() has no dispatch to resolve.
	if (object != GLOBAL_PROC && !istext(delegate))
		delegate = procpath_to_name(delegate)
	if (length(args) > 2)
		arguments = args.Copy(3)

/proc/ImmediateInvokeAsync(thingtocall, proctocall, ...)
	set waitfor = FALSE

	if (!thingtocall)
		return

	var/list/calling_arguments = length(args) > 2 ? args.Copy(3) : null

	if (thingtocall == GLOBAL_PROC)
		call(proctocall)(arglist(calling_arguments))
	else
		//By name for override resolution, see /datum/callback/New
		call(thingtocall, procpath_to_name(proctocall))(arglist(calling_arguments))

/datum/callback/proc/Invoke(...)
	if (!object)
		return
	var/list/calling_arguments = arguments
	if (length(args))
		if (length(arguments))
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
		else
			calling_arguments = args
	if (object == GLOBAL_PROC)
		return call(delegate)(arglist(calling_arguments))
	return call(object, delegate)(arglist(calling_arguments))

//copy and pasted because fuck proc overhead
/datum/callback/proc/InvokeAsync(...)
	set waitfor = FALSE
	if (!object)
		return
	var/list/calling_arguments = arguments
	if (length(args))
		if (length(arguments))
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
		else
			calling_arguments = args
	if (object == GLOBAL_PROC)
		return call(delegate)(arglist(calling_arguments))
	return call(object, delegate)(arglist(calling_arguments))