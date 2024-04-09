function echoRemovalGUI()
    % Step 1: Load Audio File
    [input_audio, Fs] = audioread('/MATLAB Drive/nokia-iphone-a28e6ab4-dccd-3836-962c-52d5d272ead7-42372.mp3');

    % Initialize echo parameters
    delay = 0.5; % initial delay
    gain = 0.5; % initial gain
    cutoff_frequency = 1000; % initial cutoff frequency
    order = 100; % initial filter order

    % Add Echo
    echoed_audio = input_audio + gain * [zeros(round(delay*Fs), size(input_audio, 2)); input_audio(1:end-round(delay*Fs), :)];

    % Remove Echo (using simple FIR filter)
    normalized_cutoff_frequency = cutoff_frequency / (Fs / 2);
    b = fir1(order, normalized_cutoff_frequency);
    de_echoed_audio = filter(b, 1, echoed_audio);

    % Create GUI
    fig = figure('Position', [200, 200, 800, 600], 'Name', 'Echo Removal GUI');

    % Plot Original Sound Waveform
    subplot(3,1,1);
    t_original = (0:length(input_audio)-1) / Fs;
    plot(t_original, input_audio);
    title('Original Sound');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Plot Echoed Sound Waveform
    subplot(3,1,2);
    t_echoed = (0:length(echoed_audio)-1) / Fs;
    plot(t_echoed, echoed_audio);
    title('Echoed Sound');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Plot De-echoed Sound Waveform
    subplot(3,1,3);
    t_de_echoed = (0:length(de_echoed_audio)-1) / Fs;
    plot(t_de_echoed, de_echoed_audio);
    title('De-Echoed Sound');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Add sliders to control echo parameters
    delay_slider = uicontrol('Style', 'slider', 'Min', 0, 'Max', 1, 'Value', delay, 'Position', [100, 50, 200, 20], 'Callback', @updateEcho);
    uicontrol('Style', 'text', 'String', 'Delay', 'Position', [40, 50, 50, 20]);
    
    gain_slider = uicontrol('Style', 'slider', 'Min', 0, 'Max', 1, 'Value', gain, 'Position', [100, 20, 200, 20], 'Callback', @updateEcho);
    uicontrol('Style', 'text', 'String', 'Gain', 'Position', [40, 20, 50, 20]);
    
    cutoff_slider = uicontrol('Style', 'slider', 'Min', 20, 'Max', 20000, 'Value', cutoff_frequency, 'Position', [500, 50, 200, 20], 'Callback', @updateEcho);
    uicontrol('Style', 'text', 'String', 'Cutoff Freq', 'Position', [420, 50, 80, 20]);
    
    order_slider = uicontrol('Style', 'slider', 'Min', 1, 'Max', 1000, 'Value', order, 'Position', [500, 20, 200, 20], 'Callback', @updateEcho);
    uicontrol('Style', 'text', 'String', 'Filter Order', 'Position', [420, 20, 80, 20]);

    % Add buttons to play audio
    uicontrol('Style', 'pushbutton', 'String', 'Play Original', 'Position', [50, 400, 100, 30], 'Callback', @(~,~)playAudio(input_audio, Fs));
    uicontrol('Style', 'pushbutton', 'String', 'Play Echoed', 'Position', [200, 400, 100, 30], 'Callback', @(~,~)playAudio(echoed_audio, Fs));
    uicontrol('Style', 'pushbutton', 'String', 'Play De-Echoed', 'Position', [350, 400, 120, 30], 'Callback', @(~,~)playAudio(de_echoed_audio, Fs));

    % Function to update echo parameters
    function updateEcho(~, ~)
        delay = get(delay_slider, 'Value');
        gain = get(gain_slider, 'Value');
        cutoff_frequency = get(cutoff_slider, 'Value');
        order = get(order_slider, 'Value');

        % Add Echo
        echoed_audio = input_audio + gain * [zeros(round(delay*Fs), size(input_audio, 2)); input_audio(1:end-round(delay*Fs), :)];

        % Remove Echo (using simple FIR filter)
        normalized_cutoff_frequency = cutoff_frequency / (Fs / 2);
        b = fir1(order, normalized_cutoff_frequency);
        de_echoed_audio = filter(b, 1, echoed_audio);

        % Update waveforms
        subplot(3,1,2);
        plot(t_echoed, echoed_audio);
        title('Echoed Sound');
        xlabel('Time (s)');
        ylabel('Amplitude');

        subplot(3,1,3);
        plot(t_de_echoed, de_echoed_audio);
        title('De-Echoed Sound');
        xlabel('Time (s)');
        ylabel('Amplitude');
    end

    % Function to play audio
    function playAudio(audio, Fs)
        sound(audio, Fs);
    end
end
