classdef app1test < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        Menu                       matlab.ui.container.Menu
        SaveMenu                   matlab.ui.container.Menu
        HelpMenu                   matlab.ui.container.Menu
        ExitMenu                   matlab.ui.container.Menu
        UIAxes                     matlab.ui.control.UIAxes
        SimulationTypeButtonGroup  matlab.ui.container.ButtonGroup
        SingleDroneButton          matlab.ui.control.RadioButton
        MultipleDroneMultiHopChainButton  matlab.ui.control.RadioButton
        MultipleDroneMultiHopEfficientButton  matlab.ui.control.RadioButton
        ParametersPanel            matlab.ui.container.Panel
        RangeSliderLabel           matlab.ui.control.Label
        RangeSlider                matlab.ui.control.Slider
        XcoordinateEditFieldLabel  matlab.ui.control.Label
        XcoordinateEditField       matlab.ui.control.NumericEditField
        YcoordinateEditFieldLabel  matlab.ui.control.Label
        YcoordinateEditField       matlab.ui.control.NumericEditField
        BaseStationLabel           matlab.ui.control.Label
        NumofStopsSpinnerLabel     matlab.ui.control.Label
        NumofStopsSpinner          matlab.ui.control.Spinner
        RandomseedDropDownLabel    matlab.ui.control.Label
        RandomseedDropDown         matlab.ui.control.DropDown
        StartButton                matlab.ui.control.StateButton
        CancelButton               matlab.ui.control.StateButton
        ClearButton                matlab.ui.control.StateButton
        OutputPanel                matlab.ui.container.Panel
        TotalCostLabel             matlab.ui.control.Label
        TimeElapsedLabel           matlab.ui.control.Label
        timeLabel                  matlab.ui.control.Label
        costLabel                  matlab.ui.control.Label
        NumdronesusedLabel         matlab.ui.control.Label
        numdronesLabel             matlab.ui.control.Label
    end

    methods (Access = private)

        % Value changed function: StartButton
        function StartButtonValueChanged(app, event)
            value = app.StartButton.Value;
            run singleDroneScenario.m
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 695 546];
            app.UIFigure.Name = 'UI Figure';

            % Create Menu
            app.Menu = uimenu(app.UIFigure);
            app.Menu.Text = 'Menu';

            % Create SaveMenu
            app.SaveMenu = uimenu(app.Menu);
            app.SaveMenu.Text = 'Save';

            % Create HelpMenu
            app.HelpMenu = uimenu(app.Menu);
            app.HelpMenu.Text = 'Help';

            % Create ExitMenu
            app.ExitMenu = uimenu(app.Menu);
            app.ExitMenu.Text = 'Exit';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.GridAlpha = 0.15;
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [10 224 395 312];

            % Create SimulationTypeButtonGroup
            app.SimulationTypeButtonGroup = uibuttongroup(app.UIFigure);
            app.SimulationTypeButtonGroup.Title = 'Simulation Type';
            app.SimulationTypeButtonGroup.FontWeight = 'bold';
            app.SimulationTypeButtonGroup.Position = [426 407 260 106];

            % Create SingleDroneButton
            app.SingleDroneButton = uiradiobutton(app.SimulationTypeButtonGroup);
            app.SingleDroneButton.Text = 'Single Drone';
            app.SingleDroneButton.Position = [11 60 91 22];
            app.SingleDroneButton.Value = true;

            % Create MultipleDroneMultiHopChainButton
            app.MultipleDroneMultiHopChainButton = uiradiobutton(app.SimulationTypeButtonGroup);
            app.MultipleDroneMultiHopChainButton.Text = 'Multiple Drone Multi-Hop (Chain)';
            app.MultipleDroneMultiHopChainButton.Position = [11 38 198 22];

            % Create MultipleDroneMultiHopEfficientButton
            app.MultipleDroneMultiHopEfficientButton = uiradiobutton(app.SimulationTypeButtonGroup);
            app.MultipleDroneMultiHopEfficientButton.Text = 'Multiple Drone Multi-Hop (Efficient)';
            app.MultipleDroneMultiHopEfficientButton.Position = [11 16 209 22];

            % Create ParametersPanel
            app.ParametersPanel = uipanel(app.UIFigure);
            app.ParametersPanel.Title = 'Parameters';
            app.ParametersPanel.FontWeight = 'bold';
            app.ParametersPanel.Position = [426 106 260 293];

            % Create RangeSliderLabel
            app.RangeSliderLabel = uilabel(app.ParametersPanel);
            app.RangeSliderLabel.HorizontalAlignment = 'right';
            app.RangeSliderLabel.FontWeight = 'bold';
            app.RangeSliderLabel.Position = [17 241 42 22];
            app.RangeSliderLabel.Text = 'Range';

            % Create RangeSlider
            app.RangeSlider = uislider(app.ParametersPanel);
            app.RangeSlider.Position = [80 250 148 3];

            % Create XcoordinateEditFieldLabel
            app.XcoordinateEditFieldLabel = uilabel(app.ParametersPanel);
            app.XcoordinateEditFieldLabel.HorizontalAlignment = 'right';
            app.XcoordinateEditFieldLabel.Position = [22 167 83 22];
            app.XcoordinateEditFieldLabel.Text = 'X-coordinate';

            % Create XcoordinateEditField
            app.XcoordinateEditField = uieditfield(app.ParametersPanel, 'numeric');
            app.XcoordinateEditField.Position = [113 167 29 22];

            % Create YcoordinateEditFieldLabel
            app.YcoordinateEditFieldLabel = uilabel(app.ParametersPanel);
            app.YcoordinateEditFieldLabel.HorizontalAlignment = 'right';
            app.YcoordinateEditFieldLabel.Position = [22 137 83 22];
            app.YcoordinateEditFieldLabel.Text = 'Y-coordinate';

            % Create YcoordinateEditField
            app.YcoordinateEditField = uieditfield(app.ParametersPanel, 'numeric');
            app.YcoordinateEditField.Position = [113 137 29 22];

            % Create BaseStationLabel
            app.BaseStationLabel = uilabel(app.ParametersPanel);
            app.BaseStationLabel.FontWeight = 'bold';
            app.BaseStationLabel.Position = [22 188 78 22];
            app.BaseStationLabel.Text = 'Base Station';

            % Create NumofStopsSpinnerLabel
            app.NumofStopsSpinnerLabel = uilabel(app.ParametersPanel);
            app.NumofStopsSpinnerLabel.HorizontalAlignment = 'right';
            app.NumofStopsSpinnerLabel.FontWeight = 'bold';
            app.NumofStopsSpinnerLabel.Position = [17 97 87 22];
            app.NumofStopsSpinnerLabel.Text = 'Num. of Stops';

            % Create NumofStopsSpinner
            app.NumofStopsSpinner = uispinner(app.ParametersPanel);
            app.NumofStopsSpinner.Limits = [3 200];
            app.NumofStopsSpinner.ValueDisplayFormat = '%.0f';
            app.NumofStopsSpinner.Position = [124 97 53 22];
            app.NumofStopsSpinner.Value = 20;

            % Create RandomseedDropDownLabel
            app.RandomseedDropDownLabel = uilabel(app.ParametersPanel);
            app.RandomseedDropDownLabel.HorizontalAlignment = 'right';
            app.RandomseedDropDownLabel.FontWeight = 'bold';
            app.RandomseedDropDownLabel.Position = [17 51 85 22];
            app.RandomseedDropDownLabel.Text = 'Random-seed';

            % Create RandomseedDropDown
            app.RandomseedDropDown = uidropdown(app.ParametersPanel);
            app.RandomseedDropDown.Items = {'twister', 'simdTwister', 'combRecursive', 'philox', 'threefry', 'multFibonacci', 'v5uniform', 'v5normal', 'v4'};
            app.RandomseedDropDown.Position = [118 51 100 22];
            app.RandomseedDropDown.Value = 'twister';

            % Create StartButton
            app.StartButton = uibutton(app.UIFigure, 'state');
            app.StartButton.ValueChangedFcn = createCallbackFcn(app, @StartButtonValueChanged, true);
            app.StartButton.Text = 'Start';
            app.StartButton.Position = [443 58 100 22];

            % Create CancelButton
            app.CancelButton = uibutton(app.UIFigure, 'state');
            app.CancelButton.Text = 'Cancel';
            app.CancelButton.Position = [565 58 100 22];

            % Create ClearButton
            app.ClearButton = uibutton(app.UIFigure, 'state');
            app.ClearButton.Text = 'Clear';
            app.ClearButton.Position = [565 22 100 22];

            % Create OutputPanel
            app.OutputPanel = uipanel(app.UIFigure);
            app.OutputPanel.Title = 'Output';
            app.OutputPanel.FontWeight = 'bold';
            app.OutputPanel.Position = [36 106 264 108];

            % Create TotalCostLabel
            app.TotalCostLabel = uilabel(app.OutputPanel);
            app.TotalCostLabel.Position = [62 30 62 22];
            app.TotalCostLabel.Text = 'Total Cost:';

            % Create TimeElapsedLabel
            app.TimeElapsedLabel = uilabel(app.OutputPanel);
            app.TimeElapsedLabel.Position = [42 51 82 22];
            app.TimeElapsedLabel.Text = 'Time Elapsed:';

            % Create timeLabel
            app.timeLabel = uilabel(app.OutputPanel);
            app.timeLabel.Position = [145 51 28 22];
            app.timeLabel.Text = 'time';

            % Create costLabel
            app.costLabel = uilabel(app.OutputPanel);
            app.costLabel.Position = [145 30 28 22];
            app.costLabel.Text = 'cost';

            % Create NumdronesusedLabel
            app.NumdronesusedLabel = uilabel(app.OutputPanel);
            app.NumdronesusedLabel.Position = [17 9 107 22];
            app.NumdronesusedLabel.Text = 'Num. drones used:';

            % Create numdronesLabel
            app.numdronesLabel = uilabel(app.OutputPanel);
            app.numdronesLabel.Position = [145 9 69 22];
            app.numdronesLabel.Text = 'num drones';
        end
    end

    methods (Access = public)

        % Construct app
        function app = app1test

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end