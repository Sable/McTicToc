aspect arrayGrowingAspect

properties
    cSize1 = 0;
    cSize2 = 0;
    fSize1 = 0;
    fSize2 = 0;
end

methods
    function updateCSize(this, val)
        if this.cSize1 < val(1)
            this.cSize1 = val(1);
        end
        if this.cSize2 < val(2)
            this.cSize2 = val(2);
        end
    end
    function updateFSize(this, val)
        if this.fSize1 < val(1)
            this.fSize1 = val(1);
        end
        if this.fSize2 < val(2)
            this.fSize2 = val(2);
        end
    end
    function ans = getCSize(this)
        ans(1) = this.cSize1; 
        ans(2) = this.cSize2;
    end
    function ans = getFSize(this)
        ans(1) = this.fSize1;
        ans(2) = this.fSize2;
    end
end

patterns
    corlist : set(correctionLIST)
    facetclist : set(facetCROSSLIST)
    executionMain : execution(Benchmark);
end

actions
    actCor : after corlist : (newVal)
       
        this.updateCSize(size(newVal));
    end
    actFacet : after facetclist : (newVal)
        
        this.updateFSize(size(newVal));
    end
    actexecution : after executionMain
        sizeC = this.getCSize();
        sizeF = this.getFSize();
        disp(['The maximal size of correctionLIST was '])
        disp(sizeC)
        disp(['The maximal size of facetCROSSLIST was '])
        disp(sizeF)
    end
end
    
end
    