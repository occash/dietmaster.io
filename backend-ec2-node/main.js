'use strict'

const cluster = require('cluster')
import {main} from './app'

cluster.schedulingPolicy = cluster.SCHED_RR

if (cluster.isMaster) {
	let cpuCount = require('os').cpus().length;
	for (let i = 0; i < cpuCount; i += 1) {
		cluster.fork()
	}
} else {
	main()
}

cluster.on('fork', function (worker) {
	console.log('Worker %d created', worker.id)
});