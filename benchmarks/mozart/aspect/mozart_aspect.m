aspect mozart_aspect
  properties
    totalTime = 0;
    fftTime = 0;
  end

  methods
    function startTotalTimer(this)
      tic;
    end

    function stopTotalTimer(this)
      this.totalTime = this.totalTime + toc;
    end

    function startFftTimer(this)
      tic;
    end

    function stopFftTimer(this)
      this.fftTime = this.fftTime + toc;
    end
  end

  patterns
    callFft2 : call(fft2(*))|call(ifft2(*));
    mainLoop : loop(k);
  end

  actions
    startTotal : before mainLoop
      this.startTotalTimer();
    end

    stopTotal : after mainLoop
      this.stopTotalTimer();
      disp(['total time: ', num2str(this.totalTime)]);
      disp(['fft time  : ', num2str(this.fftTime)]);
    end

    startFft : before callFft2
      this.startFftTimer();
    end

    stopFft : after callFft2
      this.stopFftTimer();
    end

  end

end
