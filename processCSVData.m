function processCSVData(inputFile, outputPlotFile)
% Function to process CSV data, generate a plot, and output the results.

    % Step 1: Check if file exists
    if ~isfile(inputFile)
        error('processCSVData:FileNotFound', 'The specified input file does not exist.');
    end

    % Read data from CSV file
    data = readtable(inputFile);

    % Check if the expected columns 'Time' and 'Value' exist
    if ~all(ismember({'Time', 'Value'}, data.Properties.VariableNames))
        error('processCSVData:MissingColumns','The CSV file must contain "Time" and "Value" columns.');
    end

    % Extract columns
    time = data.Time;
    value = data.Value;

    % Step 2: Validate the data
    % Ensure the data is numeric
    if ~isnumeric(time) || ~isnumeric(value)
        error('processCSVData:NonNumericData','The "Time" and "Value" columns must contain only numeric data.');
    end

    % Check for missing values (NaN)
    if any(isnan(time)) || any(isnan(value))
        error('processCSVData:unassignedOutputs','The "Time" and "Value" columns contain missing values (NaN).');
    end

    % Step 3: Generate the plot
    figure; % Create a new figure window
    plot(time, value, 'b-', 'LineWidth', 2); % Plot with a blue line
    xlabel('Time'); % Label the x-axis
    ylabel('Value'); % Label the y-axis
    title('Time vs Value'); % Title of the plot
    grid on; % Enable grid

    % Step 4: Save the plot to a file
    saveas(gcf, outputPlotFile); % Save as a PNG file

end
