% Phillip Ngo
% Classic Snake Game

function snake_gui(command_str) 

if nargin < 1
    command_str = 'initialize';
end

%% Initialize GUI
if strcmp(command_str, 'initialize') 
    
    clear, close all
    
    %% Create Figure
    
    screensize = get(0, 'screensize');
    screensize = screensize(3:4);
    figureX = 960;
    figureY = 700;
    fig = figure(                              ...
        'position', [screensize(1)/4 screensize(2)/4   ...
                     figureX figureY],                 ...
        'resize', 'on',                                ...
        'name','Snake',                                ...
        'visible', 'off',                              ...
        'MenuBar','none',                              ...
        'color', [0.5625 0.9297 0.5625],               ...
        'resize', 'off');
    
    %% Create Axes
    
    handles.axes = axes(                         ...
        'units', 'pixels',                       ...
        'position', [5 5 figureY-10 figureY-10]);
    resetAxes()

    %% Create Title and Author Texts
    
    handles.titleText = uicontrol(fig,             ...
        'style', 'text',                           ...
        'position', [figureX - 230 figureY - 90    ...
                    195 100],                      ...
        'string', 'Snake',                         ...
        'fontsize', 50,                            ...
        'fontangle', 'italic',                     ...
        'backgroundcolor', [0.5625 0.9297 0.5625]);
    
    handles.authorText = uicontrol(fig,            ...
        'style', 'text',                           ...
        'position', [figureX-80 -80                ...
                    100 100],                      ...
        'string', 'Phillip Ngo',                   ...
        'fontangle', 'italic',                     ...
        'fontsize', 8,                             ...
        'backgroundcolor', [0.5625 0.9297 0.5625]);
    
    %% Create Play Button
    
    handles.playButton = uicontrol(fig,            ...
        'Style', 'pushbutton',                     ...
        'position', [figureX/1.33 5+figureX/1.6-75 ...
                     215 75],                      ...
        'string', 'Play!',                         ...
        'fontsize', 30,                            ...
        'callback', 'snake_gui(''play'')');
    
    %% Save handles and make GUI visible
    
    set(fig, 'userdata', handles)
    set(fig, 'visible', 'on')

%% Play Callback
elseif strcmp(command_str, 'play') 
    hold on
    snake = [0 0];
    set(gcf,'CurrentCharacter', 'i')
    direction = 'i';
    gameover = false;
    point = randomPoint(snake);
    while (~gameover)
        cla
        plot(snake(:, 1), snake(:, 2), 'ks', 'markersize', 15, 'linewidth', 2)
        plot(point(1), point(2), 'ks', 'markersize', 15, 'linewidth', 2)
        resetAxes()
        if checkCollision(snake, point)
            point = randomPoint(snake);
            snake = growSnake(snake);
        end
        direction = getDirection(snake, direction);
        snake = move(snake, direction);
        gameover = gamestate(snake);
        pause(.05)
    end
    hold off
end % End of GUI initialization and callbacks


%%% METHODS - Below are helper methods for the callbacks

%% moves the snake in the given direction
function snake = move(snake, direction)
    if length(snake(:,1)) ~= 1
        for i = length(snake(:,1)):-1:2
            snake(i, 1) = snake(i-1, 1);
            snake(i, 2) = snake(i-1, 2);
        end
    end
    switch direction 
        case 'w'
            snake(1, 2) = snake(1, 2) + .5;
        case 'a'
            snake(1, 1) = snake(1, 1) - .5;
        case 's'
            snake(1, 2) = snake(1, 2) - .5;
        case 'd'
            snake(1, 1) = snake(1, 1) + .5;
    end

%% adds three blocks to the snake length
function snake = growSnake(snake)
    for i = 1:3
        snake(length(snake(:, 1))+1, 1) = snake(length(snake(:, 1)), 1);
        snake(length(snake(:, 2)), 2) = snake(length(snake(:, 2))-1, 2);
    end

%% checks if the snake is in contact with wall or itself
function state = gamestate(snake)
    state = false;
    if snake(1, 2) == 10 || snake(1, 1) == 10 || ...
       snake(1, 2) == -10 || snake(1, 1) == -10
        state = true;
    end
    if length(snake(:,1)) ~= 1 && ...
       contains([snake(2:length(snake(:,1)), 1) snake(2:length(snake(:,2)), 2)], [snake(1,1) snake(1,2)])
        state = true;
    end

%% generates a random point on the grid that is not in snake
function point = randomPoint(snake)
    xValues = [-.5 -1 -1.5 -2 -2.5 -3 -3.5 -4 -4.5 -5 -5.5 -6 -6.5 -7 -7.5 -8 -8.5 -9 -9.5 ...
               0 .5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5];
    yValues = [-.5 -1 -1.5 -2 -2.5 -3 -3.5 -4 -4.5 -5 -5.5 -6 -6.5 -7 -7.5 -8 -8.5 -9 -9.5 ...
               0 .5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5];
    point(1) = xValues(randi(39));
    point(2) = yValues(randi(39));
    while contains(snake, point) 
        point(1) = xValues(randi(39));
        point(2) = yValues(randi(39));
    end

%% resets the graph values
function resetAxes()
    plot([-10 10 10 -10 -10], [-10 -10 10 10 -10], 'k-', 'LineWidth', 10)
    set(gca, 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [], 'Color', [0.8750 1.0000 1.0000])
    axis([-10 10 -10 10])
    
%% looks at keyboard input for the direction of the snake
function direction = getDirection(snake, currentDirection)
    set(gcf, 'KeyPressFcn', @(x,y)get(gcf,'CurrentCharacter'))
    direction = get(gcf, 'CurrentCharacter');
    
    switch direction 
        case 28
            direction = 'a';
        case 29
            direction = 'd';
        case 30
            direction = 'w';
        case 31
            direction = 's';
        otherwise
            direction = currentDirection;
    end
    
    if length(snake(:,1)) ~= 1 && direction ~= currentDirection
        if currentDirection == 'w' && direction == 's'
            direction = 'w';
        elseif currentDirection == 's' && direction == 'w'
            direction = 's';
        elseif currentDirection == 'a' && direction == 'd'
            direction = 'a';
        elseif currentDirection == 'd' && direction == 'a'
            direction = 'd';
        end
    end

%% checks if the head of the snake is colliding with the given point
function state = checkCollision(snake, point)
    state = false;
    if snake(1, 2) == point(2) && snake(1, 1) == point(1)
        state = true;
    end

%% checks if a given point is within the snake
function state = contains(snake, point)
    state = false;
    for i = 1:length(snake(:,1))
        if snake(i, 1) == point(1) && snake(i, 2) == point(2)
            state = true;
        end
    end
