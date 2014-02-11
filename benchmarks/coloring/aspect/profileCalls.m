aspect profileCalls
	properties
		mainFun;
		functions = containers.Map();
		lastFun;
		currentFun;
		currentId = 0;
	end

	methods
		function main = initMain(this)
			main = this.getFun('<main>');
			this.mainFun = main;
			this.currentFun = main;
		end

		function fun = getFun(this, funName)
			if ~isKey(this.functions, funName)
				this.currentId = this.currentId + 1;
				this.functions(funName) = funMetric(this.currentId, funName);
			end
			fun = this.functions(funName);
		end

		function stackCall(this, fun)
			this.currentFun.children(fun.id) = fun;
			fun.parents(this.currentFun.id) = this.currentFun;
			this.lastFun = this.currentFun;
			this.currentFun = fun;
		end

		function unstackCall(this)
			this.currentFun = this.lastFun;
		end

		function enterFun(this, funName)
			fun = this.getFun(funName);
			fun.incCalls();
			this.stackCall(fun);
		end

		function leaveFun(this)
			this.unstackCall();
		end

		function incTime(this, funName, time)
			fun = this.functions(funName);
			fun.addTime(time);
		end

		function calls = summarize(this)
			calls = 0;
			keys = this.functions.keys();
			for i = 1:numel(keys)
				key = keys{i};
				calls = calls + this.functions(key).nbCalls;
			end
		end
	end

	patterns
		callFun: call(*);
		executionMain: mainexecution();
	end

	actions
		actCallFun: around callFun: (name)
			this.enterFun(name);
			ticVal = tic;
			proceed();
			tocVal = toc(ticVal);
			this.incTime(name, tocVal);
			this.leaveFun();
		end
		
		aTimeExecutionSart: before executionMain
			this.initMain();
			this.mainFun.totalTime = tic;
		end

		aTimeExecutionEnd: after executionMain
			this.mainFun.totalTime = toc(this.mainFun.totalTime);
			this.leaveFun();
		end

		aProfileResults: after executionMain
			disp('## CALLS');
			totalCalls = this.summarize();
			disp(['Total calls: ', num2str(totalCalls) ]);
			disp(['Total time: ', num2str(this.mainFun.totalTime, 2),'s']);
			keys = this.functions.keys();
			for i = 1:numel(keys)
				m = this.functions(keys{i});
				callPer = m.nbCalls / totalCalls * 100;
				timePer = m.totalTime / this.mainFun.totalTime * 100;
				disp([' - ', m.name]);
				disp(['    calls: ', num2str(m.nbCalls), sprintf('\t\t - '), num2str(callPer, 2), '%']);
				disp(['    time:  ', num2str(m.totalTime, 2), sprintf('\t - '), num2str(timePer, 2), '%']);
				disp( '    parents:');
				pkeys = m.parents.keys();
				for j = 1:numel(pkeys)
					parent = m.parents(pkeys{j});
					disp(['        * ', parent.name]);
				end
				disp( '    children:');
				ckeys = m.children.keys();
				for j = 1:numel(ckeys)
					child = m.children(ckeys{j});
					disp(['        * ', child.name]);
				end

			end
		end
	end
end

