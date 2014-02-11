aspect countFuncAsp
    properties
        %count = struct('checkgeometry', 0, 'quadtree', 0, 'dist2poly', 0, 'meshpoly', 0, 'mytsearch', 0, 'tinterp', 0, 'triarea', 0, 'quality', 0, 'circumcircle', 0, 'mydelaunayn', 0, 'findedge', 0, 'fixmesh', 0, 'inpoly', 0, 'other', 0);
        sumCount = 0;
    end
    methods
        function out = getCount(this)
        out = this.sumCount;
        end
    end
    patterns
        execFun : execution(*)
        execMesh: execution(mesh2d)
    end
    actions
        actExecFun : before execFun : (name, loc)
        this.sumCount = this.sumCount + 1;
%         n = loc;
%	      n = name;
%         switch n
%             case 'checkgeometry'
%      			this.count.checkgeometry = this.count.checkgeometry + 1;
%      		case 'quadtree'
%      			this.count.quadtree = this.count.quadtree + 1;
%     		case 'dist2poly'
%     			this.count.dist2poly = this.count.dist2poly + 1;
%     		case 'meshpoly'
%     			this.count.meshpoly = this.count.meshpoly + 1;
%     		case 'mytsearch'
%     			this.count.mytsearch = this.count.mytsearch + 1;
%     		case 'tinterp'
%     			this.count.tinterp = this.count.tinterp + 1;
%     		case 'triarea'
%     			this.count.triarea = this.count.triarea + 1;
%     		case 'quality'
%     			this.count.quality = this.count.quality + 1;
%     		case 'circumcircle'
%     			this.count.circumcircle = this.count.circumcircle + 1;
%     		case 'mydelaunayn'
%     			this.count.mydelaunayn = this.count.mydelaunayn + 1;
%     		case 'findedge'
%     			this.count.findedge = this.count.findedge + 1;
%     		case 'fixmesh'
%     			this.count.fixmesh = this.count.fixmesh + 1;
%      		case 'inpoly'
%      			this.count.inpoly = this.count.inpoly + 1;
%             otherwise
%                 this.count.other = this.count.other + 1;
%         end
        end
        actMesh: after execMesh
            total = this.getCount()
			this.sumCount = 0;
            disp([' total calls: ', num2str(total)]);
            %count
        end
    end

end
