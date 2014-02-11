classdef funMetric < handle
	properties
		id = 0;
		name = '';
		nbCalls = 0;
		totalTime = 0.0;
		parents;
		children;
	end
	methods
		function this = funMetric(id, name)
			if nargin > 0
				this.id = id;
				this.name = name;
				this.parents = containers.Map('KeyType','int32','ValueType','any');
				this.children = containers.Map('KeyType','int32','ValueType','any');
			end
		end

		function incCalls(this)
			this.nbCalls = this.nbCalls + 1;
		end

		function addTime(this, time)
			this.totalTime = this.totalTime + time;
		end
	end
end

