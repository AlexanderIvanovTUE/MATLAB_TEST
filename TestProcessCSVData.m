classdef TestProcessCSVData < matlab.unittest.TestCase
    properties
        TestFolder
        TestCSVFile
        OutputPlotFile
    end
    
    methods (TestMethodSetup)
        function createTestFiles(testCase)
            % Create a temporary folder for test files
            testCase.TestFolder = fullfile(tempdir, 'TestProcessCSVData');
            mkdir(testCase.TestFolder);
            
            % File paths
            testCase.TestCSVFile = fullfile(testCase.TestFolder, 'testData.csv');
            testCase.OutputPlotFile = fullfile(testCase.TestFolder, 'output_plot.png');
        end
    end

     methods (TestMethodTeardown)
        function deleteTestFiles(testCase)
            % Remove the temporary test folder
            if exist(testCase.TestFolder, 'dir')
                rmdir(testCase.TestFolder, 's');
            end
        end
    end

    methods (Test)
        function testValidData(testCase)
            % Test with valid data
            time = (1:10)';
            value = rand(10, 1);
            T = table(time, value, 'VariableNames', {'Time', 'Value'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyWarningFree(@() processCSVData(testCase.TestCSVFile, testCase.OutputPlotFile));
            testCase.verifyTrue(isfile(testCase.OutputPlotFile));
        end
        
        function testMissingValueColumn(testCase)
            % Test with missing columns
            time = (1:10)';
            T = table(time, 'VariableNames', {'Time'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processCSVData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processCSVData:MissingColumns');
        end

        function testMissingTimeColumn(testCase)
            % Test with missing columns
            value = rand(10, 1);
            T = table(value, 'VariableNames', {'Time'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processCSVData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processCSVData:MissingColumns');
        end
        
        function testALLNonNumericDataValue(testCase)
            % Test with non-numeric data
            time = (1:10)';
            value = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'}';
            T = table(time, value, 'VariableNames', {'Time', 'Value'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processCSVData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processCSVData:NonNumericData');
        end

        function testNonNumericDataValue(testCase)
            % Test with non-numeric data
            time = (1:10)';
            value = [rand(5, 1); 'd'; rand(4, 1)];
            T = table(time, value, 'VariableNames', {'Time', 'Value'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processCSVData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processCSVData:NonNumericData');
        end

        function testALLNonNumericDataTime(testCase)
            % Test with non-numeric data
            time = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'}';
            value = rand(10, 1);
            T = table(time, value, 'VariableNames', {'Time', 'Value'});
            writetable(T, testCase.TestCSVFile);
            testCase.verifyError(@() processCSVData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processCSVData:NonNumericData');
        end

        function testNonNumericDataTime(testCase)
            % Test with non-numeric data
            time = [rand(5, 1); 'd'; rand(4, 1)];
            value = rand(10, 1);
            T = table(time, value, 'VariableNames', {'Time', 'Value'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processCSVData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processCSVData:NonNumericData');
        end
        
        function testMissingValues(testCase)
            % Test with missing values
            time = (1:10)';
            value = [rand(5, 1); NaN; rand(4, 1)];
            T = table(time, value, 'VariableNames', {'Time', 'Value'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processCSVData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processCSVData:unassignedOutputs');
        end

        function testMissingTimes(testCase)
            % Test with missing values
            time = [rand(5, 1); NaN; rand(4, 1)];
            value = rand(10,1);
            T = table(time, value, 'VariableNames', {'Time', 'Value'});
            writetable(T, testCase.TestCSVFile);
            
            testCase.verifyError(@() processCSVData(testCase.TestCSVFile, testCase.OutputPlotFile), 'processCSVData:unassignedOutputs');
        end

        
    end
end
