function plot_feedback_jh(respMat, mean_coherence, coherence_frame, condition_vec)
%
% respMat
%
%

    figure
    title('No condition_vec saved...');
    
    h2r = @dk.color.hex2rgb;
    colour = { h2r('#e0433a'), h2r('#47db40'), h2r('#e0c73a'), h2r('#42ddf5') };
    
    for i = 1:4
        subplot(4,1,i); hold on;
        xlabel('Frame');
        ylabel('Coherence');

        MCi = mean_coherence{i};
        CFi = coherence_frame{i};

        nframe = size(MCi,1); % number of frames

        % draw the rectangles corresponding to trials
        absMC = abs(MCi);
        k_first = find( absMC(2:end) - absMC(1:end-1) > 0 );
        k_last = find( absMC(2:end) - absMC(1:end-1) < 0 );
        ntrial = numel(k_first);

        for j = 1:ntrial
            rectangle('Position', [k_first(j), -1.49, k_last(j)-k_first(j)+1, 3], ...
                'FaceColor', h2r('#ebebeb'), 'LineStyle', 'none');
        end

        % find row numbers of responses in current block
        r_valid = find(~isnan(respMat{i}(:, 1)));
        nresp = numel(r_valid);
        for j = 1:nresp
            r6 = respMat{i}(r_valid(j), 6);
            r7 = respMat{i}(r_valid(j), 7);
            rectangle('Position', [r6, -1.49, 12, 3], ...
                'FaceColor', colour{r7+1}, 'LineStyle', 'none');
        end
        
        % plot the blue and red lines
        plot( 1:nframe, MCi, 'r' ); 
        plot( 1:nframe, CFi, 'b' );

        % set up titles
        switch i
            case 1
                ordinal = 'First';
            case 2
                ordinal = 'Second';
            case 3
                ordinal = 'Third';
            case 4
                ordinal = 'Fourth';
        end
        
        % another switch to construct title according to condition
        if ~isempty(condition_vec)
            switch condition_vec(i)
                case 1
                    title([ordinal ' block (frequent trials, short integration)']);
                case 2
                    title([ordinal ' block (frequent trials, long integration)']);
                case 3
                    title([ordinal ' block (rare trials, short integration)']);
                case 4
                    title([ordinal ' block (rare trials, long integration)']);
            end
        end

        % add legend
        % limit axes so graphs look nice
        axis([0, nframe, -1.5, 1.5]);

    end
    
    h = zeros(5, 1);
    h(1) = scatter(NaN,NaN,NaN,[0.9215 0.9215 0.9215], 'filled'); % gray (trials)
    h(2) = scatter(NaN,NaN,NaN,[0.8784 0.2627 0.2275], 'filled');
    h(3) = scatter(NaN,NaN,NaN,[0.2784 0.8588 0.2510], 'filled');
    h(4) = scatter(NaN,NaN,NaN,[0.8784 0.7804 0.2275], 'filled');
    h(5) = scatter(NaN,NaN,NaN,[0.2588 0.8667 0.9608], 'filled');
    legend('Coherence','Mean coherence', 'Trial', 'Incorrect', 'Correct', 'Early', 'Missed');

end