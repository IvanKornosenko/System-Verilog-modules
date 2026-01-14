//traffic_light
module traffic_light (
    input logic clk,
    input logic rst_n,
    output logic red,
    output logic yellow,
    output logic green
);
//Теперь опишем состояния FSM
    typedef enum logic [1:0] {
        st_red = 2'b00,                 //здесь важно добавлять st, потому что это во-первых состояние, во вторых, иначе будет конфликт имен 
        st_yellow = 2'b01,
        st_green = 2'b10
    } state_t;

    state_t current_state, next_state;

//Зададим параметры времени в тактах
    localparam int red_time = 10;                   /*localparam - внутренняя константа. ее нельзя переопределить, используется только внутри модуля. 
                                                      parameter - как раз таки изменяется снаружи. int - 32 битное число(удобно для счетчиков и сравнений) */
    localparam int yellow_time = 2;                 //По сути Int - "храни это как 32-битное число"
    localparam int green_time = 8;

//Создадим счетчик времени
    logic [3:0] timer;              //Объявление переменной - счетчик, который имеет в себе 4-х битный регистр (хранит от 0 до 15)

//логика переходов FSM (комбинационка)
    always_comb 
    begin
        next_state = current_state;
        case(current_state)
            st_red:
            begin
                if(timer == red_time-1)  //Здесь надо подробнее. Мы задали red_time = 10 тактов. Значит (10-1 = 9) У нас идет счет от 0 до 9 - это и есть 10 тактов
                                            //Это универсальное правило счетчиков (от 0 до N-1)
                                            //Количество тактов = MAX_VALUE + 1 (то есть 9+1 = 10 тактов)
                next_state = st_green;
            end
            st_green:
            begin
                if(timer == green_time-1)
                next_state = st_yellow;
            end
            st_yellow:
            begin
                if(timer == yellow_time-1)
                next_state = st_red;
            end
            default:
            begin
                next_state = st_red;
            end
        endcase
    end
//Регистр состояния (для FSM, логика)
    always_ff @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            current_state <= st_red;
        else
            current_state <= next_state;
    end

//Теперь описание счетчика (логика)
    always_ff @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            timer <= 0;
        else 
        if(current_state != next_state)             //!= это не равно (оператор сравнения)
            timer <= 0;                                 //сменили состояние - обнулили таймер
        else
            timer <= timer + 1;                         //считаем
    end

//ВЫХОДЫ
    always_comb 
    begin
        red = 0;
        green = 0;
        yellow = 0;

    case (current_state)                    //current само собой, потому что Мур
        st_red:    red    = 1;                 //Это защита от непредсказуемого поведения. Если мы потом в case ничего не назначим, сигналы остаются 0.
        st_green:  green  = 1;
        st_yellow: yellow = 1;
    endcase
    end
endmodule





