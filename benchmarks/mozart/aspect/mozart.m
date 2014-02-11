function res = mozart(img, kIterations, lambda, I, rngSeed, showPlot)

    % Optional arguments
    if nargin < 5
        rngSeed = -1;
    end
    if nargin < 6
        showPlot = 0;
    end



    img = double(rgb2gray(imread(img)));

    img = img / 255;

    [m, n] = size(img);

    if rngSeed ~= -1
        rand('seed', rngSeed);
    end

    P = rand([m,n]);
    Q = rand([m,n]);

    mask = ones([m, n]);
    background = img(1,1); % retrieve the color of the background

    % build mask: set mask = 0 where we don't want to change Ps and Qs
    for row = 1:m
        col = 1;

        % move from left to right until intensity changes
        while col < n && img(row,col) == background
            mask(row,col) = 0;
            P(row,col) = 0;
            Q(row,col) = 0;
            col = col + 1;
        end

        % move from right to left until intensity changes
        col = n;
        while col >= 1 && img(row, col) == background
            mask(row, col) = 0;
            P(row,col) = 0;
            Q(row,col) = 0;
            col = col - 1;
        end

    end

    for k = 1:kIterations

        % Loop through every pixel
        for row = 2:m-1  % to stay within the image boundaries
            for col = 2:n-1
                if (mask(row, col) == 0)
                    continue;
                end

                neighbourPAVG = (P(row-1,col) + P(row,col-1) + P(row,col+1) + P(row+1,col))/4;
                neighbourQAVG = (Q(row-1,col) + Q(row,col-1) + Q(row,col+1) + Q(row+1,col))/4;

                R = -I(1)*P(row,col) -I(2)*Q(row,col) + I(3) / (sqrt(P(row,col)^2 + Q(row,col)^2 + 1));

                if R < 0
                    R = 0;
                end

                                % Update P
                DRDP = P(row,col)/(P(row,col)^2 + Q(row,col)^2 + 1)^1.5;
                P(row,col) = neighbourPAVG + 1/(4*lambda) * (img(row, col) - R) * (DRDP);

                                % Update Q
                DRDQ = Q(row,col)/(P(row,col)^2 + Q(row,col)^2 + 1)^1.5;
                Q(row,col) = neighbourQAVG + 1/(4*lambda) * (img(row, col) - R) * (DRDQ);

            end
        end

        omegaX = pi;
        omegaY = pi;

        Cp = fft2(P);
        Cq = fft2(Q);

        C = (-(1i * omegaX * Cp) - (1i * omegaY * Cq)) / (omegaX^2 + omegaY^2);

        CpPrime = (1i * omegaX) * C;
        CqPrime = (1i * omegaY) * C;

        P = ifft2(CpPrime);
        Q = ifft2(CqPrime);

    end

    % Plot the result
    Z = abs(ifft2(C));
    Z = Z(10:size(Z, 1)-10,:); %truncate top and bottom


    if showPlot
        mesh(Z);
        title(strcat('Lambda =', num2str(lambda), ' k = ', num2str(kIterations) ));
        colormap(gray);
    end
    res = Z;
end
