aspect profileLoops
	properties
		loops = containers.Map();
		mainTime = 0.0;
		currentId = 0;
	end

	methods
		function loop = getLoop(this, loc, line)
			name = strcat(loc, ':', num2str(line));
			if ~isKey(this.loops, name)
				this.currentId = this.currentId + 1;
				this.loops(name) = loopMetric(this.currentId, name);
			end
			loop = this.loops(name);
		end
	end

	patterns
		pLoop: loop(*);
		pLoopBody: loopbody(*);
		executionMain: mainexecution();
	end

	actions
		aLoopStart: before pLoop: (loc, line)
			loop = this.getLoop(loc, line);
			loop.incExec();
			loop.timer = tic;
		end

		aLoopEnd: after pLoop: (loc, line)
			loop = this.getLoop(loc, line);
			loop.timer = toc(loop.timer);
			loop.addTime(loop.timer);
		end

		aLoopBody: before pLoopBody: (loc, line)
			loop = this.getLoop(loc, line);
			loop.incIterations();
		end

		aTimeExecutionSart: before executionMain
			this.mainTime = tic;
		end

		aTimeExecutionEnd: after executionMain
			this.mainTime = toc(this.mainTime);
		end

		aProfileResults: after executionMain
			disp('## LOOP');
			disp(['Total time: ', num2str(this.mainTime, 2),'s']);
			keys = this.loops.keys();
			for i = 1:numel(keys)
				loop = this.loops(keys{i});
				timePer = loop.totalTime / this.mainTime * 100;
				disp([' - ', loop.name]);
				disp(['    exec: ', num2str(loop.nbExec)]);
				disp(['    iterations: ', num2str(loop.nbIterations)]);
				disp(['    time:  ', num2str(loop.totalTime, 2), sprintf('\t - '), num2str(timePer, 2), '%']);
			end
		end
	end
end

