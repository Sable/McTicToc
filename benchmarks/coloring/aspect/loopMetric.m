classdef loopMetric < handle
	properties
		id = 0;
		name = '';
		nbExec = 0;
		nbIterations = 0;
		totalTime = 0.0;
		timer = 0.0;
	end
	methods
		function this = loopMetric(id, name)
			if nargin > 0
				this.id = id;
				this.name = name;
			end
		end

		function incExec(this)
			this.nbExec = this.nbExec + 1;
		end

		function incIterations(this)
			this.nbIterations = this.nbIterations + 1;
		end

		function addTime(this, time)
			this.totalTime = this.totalTime + time;
		end
	end
end

