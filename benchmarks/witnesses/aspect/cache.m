aspect cache

    properties
        cacheMap = containers.Map()
        hitCount = 0
        missCount = 0
        NOT_FOUND = -1000
    end
    
    methods
        function out = getHitCount(this)
            out = this.hitCount;
        end
        
        function out = getMissCount(this)
            out = this.missCount;
        end
        
        function [val] = useCache(this, key)
            if (isKey(this.cacheMap, key) == 1)
                val = this.cacheMap(key);
                this.hitCount = this.hitCount + 1;
            else
                val = this.NOT_FOUND;
                this.missCount = this.missCount + 1;
            end
        end
        
        function addToCache(this, key, val)
            this.cacheMap(key) = val;
        end
        
    end
    
    patterns
        %examples:
        %call (expon(..));
        %or (mod(..)) | call(bitand(..));
        callcache : call (expon(..));
        executionMain : mainexecution();
    end
    
    actions
        actcall : around callcache : (name, args)
            numericVector = cell2mat(args);
            args_str = mat2str(numericVector);
            args_str = strcat(name, ',', args_str);
            val = this.useCache(args_str);
            if (val == this.NOT_FOUND)
                proceed();
                this.addToCache(args_str, varargout{1});
            else
                varargout{1} = val;
            end
            
        end
        
        actexecution : after executionMain
            hits = this.getHitCount();
            misses = this.getMissCount();
            disp ([' total hits : ', num2str(hits )]);
            disp ([' total misses : ', num2str(misses )]);
        end
    end
end
