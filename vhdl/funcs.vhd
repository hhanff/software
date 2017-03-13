-----------------------------------------------------------------------
-- Package that declares some special functions needed for RTL netlisting
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package FUNCS is

   --- RTL netlister functions
   
   function mux_s
     (inputs : std_logic_vector;
      sel : unsigned) return std_logic;
   
   function mux_v
     (inputs : unsigned;
      sel : std_logic) return unsigned;

   function mux_v
     (inputs : unsigned;
      sel : unsigned) return unsigned;

   function mux_v
     (inputs : signed;
      sel : signed) return signed;
   
   function mux1hot_s
     (inputs : unsigned;
      sel : unsigned) return std_logic;
   
   function mux1hot_v
     (inputs : unsigned;
      sel : unsigned) return unsigned;
   
   function mux1hot_v
     (inputs : signed;
      sel : signed) return signed;
   
   type integers is array (positive range <>) of integer;
   
   function muxv_s
     (inputs : unsigned;
      choices_nb : integers;
      choices : unsigned;
      sel : unsigned) return std_logic;
   
   function muxv_v
     (inputs : unsigned;
      choices_nb : integers;
      choices : unsigned;
      sel : unsigned) return unsigned;
   
   function lat_s
     (input : std_logic;
      clk : std_logic;
      output : std_logic) return std_logic;
   
   function lat_v
     (input : unsigned;
      clk : std_logic;
      output: unsigned) return unsigned;

   function tri_s
     (input : std_logic;
      control : std_logic) return std_logic; 
 
   function tri_v
     (input : unsigned;
      control : std_logic) return unsigned; 

   FUNCTION to_stdlogic ( arg1 : BOOLEAN ) RETURN STD_LOGIC;
   FUNCTION maximum ( arg1, arg2 : INTEGER) RETURN INTEGER;
   FUNCTION minimum ( arg1, arg2 : INTEGER) RETURN INTEGER;
   FUNCTION "xor"  (arg1, arg2:SIGNED)   RETURN SIGNED;
   FUNCTION "xor"  (arg1, arg2:UNSIGNED) RETURN UNSIGNED;
   FUNCTION "not"  ( arg1 : SIGNED ) RETURN SIGNED;
   FUNCTION "not"  ( arg1 : UNSIGNED ) RETURN UNSIGNED;
   FUNCTION "and"  (arg1, arg2:SIGNED)   RETURN SIGNED;
   FUNCTION "and"  (arg1, arg2:UNSIGNED) RETURN UNSIGNED;
   FUNCTION "nand" (arg1, arg2:SIGNED)   RETURN SIGNED;
   FUNCTION "nand" (arg1, arg2:UNSIGNED) RETURN UNSIGNED;
   FUNCTION "or"   (arg1, arg2:SIGNED)   RETURN SIGNED;
   FUNCTION "or"   (arg1, arg2:UNSIGNED) RETURN UNSIGNED;
   FUNCTION "nor"  (arg1, arg2:SIGNED)   RETURN SIGNED;
   FUNCTION "nor"  (arg1, arg2:UNSIGNED) RETURN UNSIGNED;
   FUNCTION "xnor"  (arg1, arg2:SIGNED)   RETURN SIGNED;
   FUNCTION "xnor"  (arg1, arg2:UNSIGNED) RETURN UNSIGNED;
   FUNCTION nand_reduce(arg : UNSIGNED) RETURN STD_LOGIC;
   FUNCTION nand_reduce(arg : SIGNED) RETURN STD_LOGIC;
   FUNCTION eq ( l, r : UNSIGNED )          RETURN BOOLEAN ;
    --attribute builtin_subprogram of "="[UNSIGNED, UNSIGNED return BOOLEAN]: function is "stdarith_eq_uu";
   FUNCTION eq ( l, r : SIGNED )            RETURN BOOLEAN ;
    --attribute builtin_subprogram of "="[SIGNED, SIGNED return BOOLEAN]: function is "stdarith_eq_ss";

  -- Vectorized Overloaded Arithmetic Operators
   FUNCTION "+" ( arg1, arg2 : STD_LOGIC ) RETURN STD_LOGIC;
   FUNCTION "-" ( arg1, arg2 : STD_LOGIC ) RETURN STD_LOGIC;
   FUNCTION   "/"   ( l, r :          UNSIGNED ) RETURN UNSIGNED;
   FUNCTION   "/"   ( l, r :            SIGNED ) RETURN SIGNED;
   FUNCTION "MOD"   ( l, r :            SIGNED ) RETURN SIGNED;
   FUNCTION "MOD"   ( l, r :          UNSIGNED ) RETURN UNSIGNED;
   FUNCTION "REM"   ( l, r :            SIGNED ) RETURN SIGNED;
   FUNCTION "REM"   ( l, r :          UNSIGNED ) RETURN UNSIGNED;
   FUNCTION  "**"   ( l, r :            SIGNED ) RETURN SIGNED;
   FUNCTION  "**"   ( l, r :          UNSIGNED ) RETURN UNSIGNED;
   FUNCTION "sla" (arg1:UNSIGNED          ; arg2:NATURAL)  RETURN UNSIGNED ;
   FUNCTION "sla" (arg1:SIGNED            ; arg2:NATURAL)  RETURN SIGNED ;
   FUNCTION "sra" (arg1:UNSIGNED          ; arg2:NATURAL)  RETURN UNSIGNED ;
   FUNCTION "sra" (arg1:SIGNED            ; arg2:NATURAL)  RETURN SIGNED ;
   FUNCTION "sll" (arg1:UNSIGNED          ; arg2:NATURAL)  RETURN UNSIGNED ;
   FUNCTION "sll" (arg1:SIGNED            ; arg2:NATURAL)  RETURN SIGNED ;
   FUNCTION "srl" (arg1:UNSIGNED          ; arg2:NATURAL)  RETURN UNSIGNED ;
   FUNCTION "srl" (arg1:SIGNED            ; arg2:NATURAL)  RETURN SIGNED ;
   FUNCTION "rol" (arg1:UNSIGNED          ; arg2:NATURAL)  RETURN UNSIGNED ;
   FUNCTION "rol" (arg1:SIGNED            ; arg2:NATURAL)  RETURN SIGNED ;
   FUNCTION "ror" (arg1:UNSIGNED          ; arg2:NATURAL)  RETURN UNSIGNED ;
   FUNCTION "ror" (arg1:SIGNED            ; arg2:NATURAL)  RETURN SIGNED ;
 
--
-- In general, objects in this package are required to be functions.
-- For synthesizability reasons, we want the "flipflop" functions to be
-- procedures.  There is a special kludge in the rtl netlister to let
-- this work.
--
   
   procedure flipflop
     (signal input : in std_logic;
      signal clk : in std_logic;
      signal output : out std_logic);
   
   procedure flipflop
     (signal input : in unsigned;
      signal clk : in std_logic;
      signal output : out unsigned);
   
   procedure flipflop
     (signal input : in std_logic;
      signal clk : in std_logic;
      signal output : out std_logic;
      signal rst : in std_logic;
      signal value : in std_logic);
   
   procedure flipflop
     (signal input : in unsigned;
      signal clk : in std_logic;
      signal output : out unsigned;
      signal rst : in std_logic;
      signal value : in unsigned);

--
-- This is used in the special case when we need to pick a vector that
-- has been changed into a constant.  This is because the VHDL language
-- doesn't allow one to say "bits"[index]
--
 
   function readindex
     (input : unsigned;
      index : natural) return std_logic;

--
-- The following procedures insert n consecutive wait until edge
-- statements into the process. 'phase' gives the active edge ie it
-- should be either '1' or '0'
--
 
   procedure wait_clock_cycles
     (constant n : natural;
      signal clk : in std_logic;
      constant phase : in std_logic);
 
   procedure wait_clock_cycles
     (constant n : natural;
      signal clk : in bit;
      constant phase : in bit);

-- Declare Exemplar Synthesis Directive attributes
    attribute SYNTHESIS_RETURN : STRING ;
    attribute IS_SIGNED : BOOLEAN ;

end FUNCS;

package body FUNCS is

   function mux_s
     (inputs : std_logic_vector;
      sel : unsigned) return std_logic is
      variable result : std_logic;
      attribute SYNTHESIS_RETURN of result:variable is "mux";
   begin
      result := inputs ( conv_integer ( '0'&sel ));
      return result;
   end;
   
   function mux_v
     (inputs : unsigned;
      sel : std_logic) return unsigned is
      constant nb_inputs : positive := 2;
      constant size : positive := inputs'length/nb_inputs;
      variable value : integer;
      variable ins : unsigned(0 to inputs'length-1) := inputs;
      variable result : unsigned(0 to size-1);
      variable left, right : integer;
      attribute SYNTHESIS_RETURN of result:variable is "mux";
   begin
      if (sel = '1')
      then
        value := 1;
      else
        value := 0;
      end if;
      left := value*size;
      right := (value + 1)*size -1;
      for i in left to right loop
          result(i-left) := ins(i);
      end loop;
      --result := ins (value*size to (value+1)*size-1);
      return result;
   end;
   
   function mux_v
     (inputs : unsigned;
      sel : unsigned) return unsigned is
      variable value : natural := conv_integer (unsigned(sel));
      constant nb_inputs : positive := 2 ** sel'length;
      constant size : positive := inputs'length/nb_inputs;
      variable ins : unsigned(0 to inputs'length-1) := inputs;
      variable result : unsigned(0 to size-1);
      variable left, right : natural;
      attribute SYNTHESIS_RETURN of result:variable is "mux";
   begin
      left := value*size;
      right := (value + 1)*size -1;
      for i in left to right loop
          result(i-left) := ins(i);
      end loop;
      --result := ins (value*size to (value+1)*size-1);
      return result;
   end;
   
   function mux_v
     (inputs : signed;
      sel : signed) return signed is
      variable value : natural := conv_integer (unsigned(sel));
      constant nb_inputs : positive := 2 ** sel'length;
      constant size : positive := inputs'length/nb_inputs;
      variable ins : signed(0 to inputs'length-1) := inputs;
      variable result : signed(0 to size-1);
      variable left, right : natural;
      attribute SYNTHESIS_RETURN of result:variable is "mux";
   begin
      left := value*size;
      right := (value + 1)*size -1;
      for i in left to right loop
          result(i-left) := ins(i);
      end loop;
      --result := ins (value*size to (value+1)*size-1);
      return result;
   end;
   
   function mux1hot_s
     (inputs : unsigned;
      sel : unsigned) return std_logic is
      variable ins : unsigned(0 to inputs'length-1) := inputs;
      variable s : unsigned(0 to sel'length-1) := sel;
      variable result : std_logic;
      attribute SYNTHESIS_RETURN of result:variable is "mux1hot";
   begin
      for i in s'range loop
         if s(i) = '1' then
            result := ins (i);
            return result;
         end if;
      end loop;
      return '0';
   end;
   
   function mux1hot_v
     (inputs : unsigned;
      sel : unsigned) return unsigned is
      constant size : positive := inputs'length/sel'length;
      variable ins : unsigned(0 to inputs'length-1) := inputs;
      variable s : unsigned(0 to sel'length-1) := sel;
      variable result : unsigned(0 to size-1);
      variable left, right : integer;
      attribute SYNTHESIS_RETURN of result:variable is "mux1hot";
   begin
      for i in s'range loop
         if (s(i) = '1') then
            left := i*size;
            right := (i+1)*size-1;
            for j in left to right loop
               result(j-left) := ins(j);
            end loop;
            --result := ins (i*size to (i+1)*size-1);
            return result;
         end if;
      end loop;
      result := (others=>'0');
      return result;
   end;
   
   function mux1hot_v
     (inputs : signed;
      sel : signed) return signed is
      constant size : positive := inputs'length/sel'length;
      variable ins : signed(0 to inputs'length-1) := inputs;
      variable s : signed(0 to sel'length-1) := sel;
      variable result : signed(0 to size-1);
      variable left, right : integer;
      attribute SYNTHESIS_RETURN of result:variable is "mux1hot";
   begin
      for i in s'range loop
         if (s(i) = '1') then
            left := i*size;
            right := (i+1)*size-1;
            for j in left to right loop
               result(j-left) := ins(j);
            end loop;
            --result := ins (i*size to (i+1)*size-1);
            return result;
         end if;
      end loop;
      result := (others=>'0');
      return result;
   end;
   
   function muxv_s
     (inputs : unsigned;
      choices_nb : integers;
      choices : unsigned;
      sel : unsigned) return std_logic is
      variable ins : unsigned(0 to inputs'length-1) := inputs;
      variable chs : unsigned(0 to choices'length-1) := choices;
      variable ch : unsigned(0 to sel'length-1);
      variable choice_index : integer := 0;
      variable result : std_logic;
      attribute SYNTHESIS_RETURN of result:variable is "muxv";
   begin
     for i in 0 to choices_nb'length-1 loop
       for j in 1 to choices_nb(i) loop
         ch := chs (choice_index*sel'length to
                    (choice_index+1)*sel'length);
         if (sel = ch) then
           result := ins (i);
           return result;
         end if;
         choice_index := choice_index + 1;
       end loop;
     end loop;
     result := ins (choices_nb'length-1);
     return result;
   end;
   
   function muxv_v
     (inputs : unsigned;
      choices_nb : integers;
      choices : unsigned;
      sel : unsigned) return unsigned is
      constant size : positive := inputs'length/choices_nb'length;
      variable ins : unsigned(0 to inputs'length-1) := inputs;
      variable chs : unsigned(0 to choices'length-1) := choices;
      variable ch : unsigned(0 to sel'length-1);
      variable choice_index : integer := 0;
      variable result : unsigned(0 to size-1);
      variable left, right : integer;
      attribute SYNTHESIS_RETURN of result:variable is "muxv";
   begin
     for i in 0 to choices_nb'length-1 loop
       for j in 1 to choices_nb(i) loop
         left := choice_index*sel'length;
         right := (choice_index+1)*sel'length;
         for k in left to right loop
           ch(k-left) := chs(k);
         end loop;
         --ch := chs (choice_index*sel'length to
          --          (choice_index+1)*sel'length);
         if (sel = ch) then
           left := i * size;
           right := (i+1)*size-1;
           for k in left to right loop
               result(k-left) := ins(k);
           end loop;
           --result := ins (i*size to (i+1)*size-1);
           return result;
         end if;
         choice_index := choice_index + 1;
       end loop;
     end loop;
     left := (choices_nb'length-1)*size;
     right := choices_nb'length*size-1;
     for j in left to right loop
         result(j-left) := ins(j);
     end loop;
     --result := ins ((choices_nb'length-1)*size to choices_nb'length*size-1);
     return result;
   end;
   
   function lat_s
     (input : std_logic;
      clk : std_logic;
      output : std_logic) return std_logic is
      variable result : std_logic;
      attribute SYNTHESIS_RETURN of result:variable is "lat";
   begin
     if (clk = '1')  then
       result := input;
       return result;
     else
       result := output;
       return result;
     end if;
   end;
   
   function lat_v
     (input : unsigned;
      clk : std_logic;
      output: unsigned) return unsigned is
      variable result : unsigned(output'range);
      attribute SYNTHESIS_RETURN of result:variable is "lat";
   begin
     if (clk = '1')  then
       result := input;
       return result;
     else
       result := output;
       return result;
     end if;
   end;

   function tri_s
     (input : std_logic;
      control : std_logic) return std_logic is
      variable result : std_logic;
      attribute SYNTHESIS_RETURN of result:variable is "tri";
   begin
     if (control = '1') then
       result := input;
       return result;
     else
       result := 'Z';
       return result;
     end if;
   end;

   function tri_v
     (input : unsigned;
      control : std_logic) return unsigned is
      variable result : unsigned(input'range);
      attribute SYNTHESIS_RETURN of result:variable is "tri";
   begin
     if (control = '1') then
       result := input;
       return result;
     else
       result := (others => 'Z');
       return result;
     end if;
   end;

--
-- Arithmetic, other functions missing from ieee.std_logic_arith
--

    TYPE stdlogic_1d IS ARRAY (std_ulogic) OF std_ulogic;
    TYPE stdlogic_table IS ARRAY(std_ulogic, std_ulogic) OF std_ulogic;
    TYPE stdlogic_boolean_table IS ARRAY(std_ulogic, std_ulogic) OF BOOLEAN;
    CONSTANT eq_table : stdlogic_boolean_table := (
    --
     ----------------------------------------------------------------------------
    --      |  U       X      0     1      Z      W      L      H      D |   |
    --
     ----------------------------------------------------------------------------
    ( FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE ),  -- | U |
    ( FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE ),  -- | X |
    ( FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ),  -- | 0 |
    ( FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE ),  -- | 1 |
    ( FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE ),  -- | Z |
    ( FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE ),  -- | W |
    ( FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE ),  -- | L |
    ( FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE ),  -- | H |
    ( FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE )   -- | D |
    );

	-- truth table for "and" function
    CONSTANT and_table : stdlogic_table := (
	--      ----------------------------------------------------
	--      |  U    X    0    1    Z    W    L    H    D         |   |
	--      ----------------------------------------------------
            ( 'U', 'U', '0', 'U', 'U', 'U', '0', 'U', 'U' ),  -- | U |
            ( 'U', 'X', '0', 'X', 'X', 'X', '0', 'X', 'X' ),  -- | X |
            ( '0', '0', '0', '0', '0', '0', '0', '0', '0' ),  -- | 0 |
            ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', 'X' ),  -- | 1 |
   	        ( 'U', 'X', '0', 'X', 'X', 'X', '0', 'X', 'X' ),  -- | Z |
   	        ( 'U', 'X', '0', 'X', 'X', 'X', '0', 'X', 'X' ),  -- | W |
   	        ( '0', '0', '0', '0', '0', '0', '0', '0', '0' ),  -- | L |
   	        ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', 'X' ),  -- | H |
   	        ( 'U', 'X', '0', 'X', 'X', 'X', '0', 'X', 'X' )   -- | D |
    );

	-- truth table for "or" function
	CONSTANT or_table : stdlogic_table := (
	--      ----------------------------------------------------
	--      |  U    X    0    1    Z    W    L    H    D         |   |
	--      ----------------------------------------------------
                ( 'U', 'U', 'U', '1', 'U', 'U', 'U', '1', 'U' ),  -- | U |
	        ( 'U', 'X', 'X', '1', 'X', 'X', 'X', '1', 'X' ),  -- | X |
	        ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', 'X' ),  -- | 0 |
	        ( '1', '1', '1', '1', '1', '1', '1', '1', '1' ),  -- | 1 |
	        ( 'U', 'X', 'X', '1', 'X', 'X', 'X', '1', 'X' ),  -- | Z |
	        ( 'U', 'X', 'X', '1', 'X', 'X', 'X', '1', 'X' ),  -- | W |
	        ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', 'X' ),  -- | L |
	        ( '1', '1', '1', '1', '1', '1', '1', '1', '1' ),  -- | H |
	        ( 'U', 'X', 'X', '1', 'X', 'X', 'X', '1', 'X' )   -- | D |
    );


	-- truth table for "xor" function
	CONSTANT xor_table : stdlogic_table := (
	--      ----------------------------------------------------
	--      |  U    X    0    1    Z    W    L    H    D         |   |
	--      ----------------------------------------------------
                ( 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U' ),  -- | U |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' ),  -- | X |
	        ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', 'X' ),  -- | 0 |
	        ( 'U', 'X', '1', '0', 'X', 'X', '1', '0', 'X' ),  -- | 1 |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' ),  -- | Z |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' ),  -- | W |
	        ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', 'X' ),  -- | L |
	        ( 'U', 'X', '1', '0', 'X', 'X', '1', '0', 'X' ),  -- | H |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' )   -- | D |
    );


	-- truth table for "not" function
	CONSTANT not_table: stdlogic_1D :=
	--  -------------------------------------------------
	--  |   U    X    0    1    Z    W    L    H    D   |
	--  -------------------------------------------------
	     ( 'U', 'X', '1', '0', 'X', 'X', '1', '0', 'X' );

    FUNCTION "+"  ( arg1, arg2 : STD_LOGIC ) RETURN STD_LOGIC IS
	-- truth table for "xor" function
	CONSTANT xor_table : stdlogic_table := (
	--      ----------------------------------------------------
	--      |  U    X    0    1    Z    W    L    H    D         |   |
	--      ----------------------------------------------------
                ( 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U' ),  -- | U |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' ),  -- | X |
	        ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', 'X' ),  -- | 0 |
	        ( 'U', 'X', '1', '0', 'X', 'X', '1', '0', 'X' ),  -- | 1 |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' ),  -- | Z |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' ),  -- | W |
	        ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', 'X' ),  -- | L |
	        ( 'U', 'X', '1', '0', 'X', 'X', '1', '0', 'X' ),  -- | H |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' )   -- | D |
    );
         VARIABLE result : STD_LOGIC ;
         -- Arithmetic addition of two logic types. Works as XOR.
         ATTRIBUTE synthesis_return OF result:VARIABLE IS "XOR" ; 
    BEGIN
        result := xor_table( arg1, arg2 );
        RETURN result ;
    END "+";

    FUNCTION "-"  ( arg1, arg2 : std_logic ) RETURN std_logic IS
	-- truth table for "xor" function
	CONSTANT xor_table : stdlogic_table := (
	--      ----------------------------------------------------
	--      |  U    X    0    1    Z    W    L    H    D         |   |
	--      ----------------------------------------------------
                ( 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U' ),  -- | U |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' ),  -- | X |
	        ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', 'X' ),  -- | 0 |
	        ( 'U', 'X', '1', '0', 'X', 'X', '1', '0', 'X' ),  -- | 1 |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' ),  -- | Z |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' ),  -- | W |
	        ( 'U', 'X', '0', '1', 'X', 'X', '0', '1', 'X' ),  -- | L |
	        ( 'U', 'X', '1', '0', 'X', 'X', '1', '0', 'X' ),  -- | H |
	        ( 'U', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X' )   -- | D |
    );
        -- Arithmetic addition of logic types. Same as XOR.
        VARIABLE result : std_logic ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "XOR" ; 
    BEGIN
        result := xor_table( arg1, arg2 );
        RETURN result ;
    END "-";

    FUNCTION zxt( q : UNSIGNED; i : INTEGER ) RETURN UNSIGNED IS
        VARIABLE qs : UNSIGNED (1 TO i);
        VARIABLE qt : UNSIGNED (1 TO q'length);
        -- Hidden function. Synthesis directives are present in its callers
    BEGIN
        qt := q;
        IF i < q'length THEN
            qs := qt( (q'length-i+1) TO qt'right);
        ELSIF i > q'length THEN
            qs := (OTHERS=>'0');
            qs := qs(1 TO (i-q'length)) & qt;
        ELSE
            qs := qt;
        END IF;
        RETURN qs;
    END;

    FUNCTION eq  ( l, r : STD_LOGIC ) RETURN BOOLEAN IS
        -- Equal for two logic types  
        VARIABLE result : BOOLEAN ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "EQ" ; 
    BEGIN
        result := eq_table( l, r );
        RETURN result ;
    END;

    FUNCTION eq  ( l,r : UNSIGNED ) RETURN BOOLEAN IS
        CONSTANT ml  : INTEGER := maximum( l'length, r'length );
        VARIABLE lt  : UNSIGNED ( 1 TO ml );
        VARIABLE rt  : UNSIGNED ( 1 TO ml );
        -- Arithmetic Equal for two Unsigned vectors  
        VARIABLE result : BOOLEAN ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "EQ" ; 
    BEGIN
        lt := zxt( l, ml );
        rt := zxt( r, ml );
        FOR i IN lt'range LOOP
            IF NOT eq( lt(i), rt(i) ) THEN
               result := FALSE ;
               RETURN result;
            END IF;
        END LOOP;
        RETURN TRUE;
    END;

    FUNCTION eq  ( l,r : SIGNED ) RETURN BOOLEAN IS
        CONSTANT len  : INTEGER := maximum( l'length, r'length );
        VARIABLE lt, rt  : UNSIGNED ( len-1 downto 0 ) := (OTHERS => '0');
        -- Arithmetic Equal for two Signed vectors  
        VARIABLE result : BOOLEAN ;
        ATTRIBUTE is_signed OF l:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF r:CONSTANT IS TRUE ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "EQ" ; 
    BEGIN
         assert l'length > 1 AND r'length > 1
           report "SIGNED vector must be atleast 2 bits wide"
           severity ERROR;
      lt := (OTHERS => l(l'left)) ;
      lt(l'length - 1 DOWNTO 0) := UNSIGNED(l);
      rt := (OTHERS => r(r'left)) ;
      rt(r'length - 1 DOWNTO 0) := UNSIGNED(r);
      result := (eq( lt, rt ));
      RETURN result ;
    END;

     FUNCTION "not"  ( arg1 : SIGNED ) RETURN SIGNED IS
         VARIABLE result : SIGNED ( arg1'RANGE ) := (Others => 'X');
        -- Vector-wide NOT 
        -- Synthesizable as is.
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "NOT" ; 
     begin
         for i in result'range loop
             result(i) := not_table( arg1(i) );
         end loop;
         return result;
     end "not";

     FUNCTION "not"  ( arg1 : UNSIGNED ) RETURN UNSIGNED IS
         VARIABLE result : UNSIGNED ( arg1'RANGE ) := (Others => 'X');
        -- Vector-wide NOT 
        -- Synthesizable as is.
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "NOT" ; 
     begin
         for i in result'range loop
             result(i) := not_table( arg1(i) );
         end loop;
         return result;
     end "not";

     FUNCTION "and"  ( arg1,arg2 : UNSIGNED ) RETURN UNSIGNED IS
         CONSTANT ml  : integer := maximum( arg1'LENGTH, arg2'LENGTH );
         VARIABLE lt  : UNSIGNED ( 1 to ml );
         VARIABLE rt  : UNSIGNED ( 1 to ml );
         VARIABLE res : UNSIGNED ( 1 to ml );
        -- Vector-wide AND with zero-extend
        ATTRIBUTE synthesis_return OF res:VARIABLE IS "AND" ; 
     begin
         lt := zxt( arg1, ml );
         rt := zxt( arg2, ml );
         FOR i IN res'RANGE LOOP
             res(i) := and_table( lt(i), rt(i) );
         END LOOP;
         RETURN res;
     end "and";

     FUNCTION "nand"  ( arg1,arg2 : UNSIGNED ) RETURN UNSIGNED IS
         CONSTANT ml  : integer := maximum( arg1'LENGTH, arg2'LENGTH );
         VARIABLE lt  : UNSIGNED ( 1 to ml );
         VARIABLE rt  : UNSIGNED ( 1 to ml );
         VARIABLE res : UNSIGNED ( 1 to ml );
        -- Vector-wide NAND with zero-extend
        ATTRIBUTE synthesis_return OF res:VARIABLE IS "NAND" ; 
     begin
         lt := zxt( arg1, ml );
         rt := zxt( arg2, ml );
         FOR i IN res'RANGE LOOP
             res(i) := not_table( and_table( lt(i), rt(i) ) );
         END LOOP;
         RETURN res;
     end "nand";

     FUNCTION "or"  ( arg1,arg2 : UNSIGNED ) RETURN UNSIGNED IS
         CONSTANT ml  : integer := maximum( arg1'LENGTH, arg2'LENGTH );
         VARIABLE lt  : UNSIGNED ( 1 to ml );
         VARIABLE rt  : UNSIGNED ( 1 to ml );
         VARIABLE res : UNSIGNED ( 1 to ml );
        -- Vector-wide OR with zero-extend
        ATTRIBUTE synthesis_return OF res:VARIABLE IS "OR" ; 
     begin
         lt := zxt( arg1, ml );
         rt := zxt( arg2, ml );
         FOR i IN res'RANGE LOOP
             res(i) := or_table( lt(i), rt(i) );
         END LOOP;
         RETURN res;
     end "or";

     FUNCTION "nor"  ( arg1,arg2 : UNSIGNED ) RETURN UNSIGNED IS
         CONSTANT ml  : integer := maximum( arg1'LENGTH, arg2'LENGTH );
         VARIABLE lt  : UNSIGNED ( 1 to ml );
         VARIABLE rt  : UNSIGNED ( 1 to ml );
         VARIABLE res : UNSIGNED ( 1 to ml );
        -- Vector-wide NOR with zero-extend
        ATTRIBUTE synthesis_return OF res:VARIABLE IS "NOR" ; 
     begin
         lt := zxt( arg1, ml );
         rt := zxt( arg2, ml );
         FOR i IN res'RANGE LOOP
             res(i) := not_table( or_table( lt(i), rt(i) ) );
         END LOOP;
         RETURN res;
     end "nor";

     FUNCTION "and"  ( arg1,arg2 : SIGNED ) RETURN SIGNED IS
       CONSTANT len : INTEGER := maximum(arg1'length,arg2'length) ;
       VARIABLE a,b : UNSIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
       VARIABLE answer : SIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
        -- Vector-wide AND with sign extend 
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF arg2:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF answer:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF answer:VARIABLE IS "AND" ; 
     BEGIN
       a := (OTHERS => arg1(arg1'left)) ;
       a(arg1'length - 1 DOWNTO 0) := UNSIGNED(arg1);
       b := (OTHERS => arg2(arg2'left)) ;
       b(arg2'length - 1 DOWNTO 0) := UNSIGNED(arg2);
       answer := SIGNED(a and b);
       RETURN (answer);
     end "and";

     FUNCTION "nand"  ( arg1,arg2 : SIGNED ) RETURN SIGNED IS
       CONSTANT len : INTEGER := maximum(arg1'length,arg2'length) ;
       VARIABLE a,b : UNSIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
       VARIABLE answer : SIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
        -- Vector-wide NAND with sign extend 
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF arg2:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF answer:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF answer:VARIABLE IS "NAND" ; 
     BEGIN
       a := (OTHERS => arg1(arg1'left)) ;
       a(arg1'length - 1 DOWNTO 0) := UNSIGNED(arg1);
       b := (OTHERS => arg2(arg2'left)) ;
       b(arg2'length - 1 DOWNTO 0) := UNSIGNED(arg2);
       answer := SIGNED(a nand b);
       RETURN (answer);
     end "nand";

     FUNCTION "or"  ( arg1,arg2 : SIGNED ) RETURN SIGNED IS
       CONSTANT len : INTEGER := maximum(arg1'length,arg2'length) ;
       VARIABLE a,b : UNSIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
       VARIABLE answer : SIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
        -- Vector-wide OR with sign extend 
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF arg2:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF answer:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF answer:VARIABLE IS "OR" ; 
     BEGIN
       a := (OTHERS => arg1(arg1'left)) ;
       a(arg1'length - 1 DOWNTO 0) := UNSIGNED(arg1);
       b := (OTHERS => arg2(arg2'left)) ;
       b(arg2'length - 1 DOWNTO 0) := UNSIGNED(arg2);
       answer := SIGNED(a or b);
       RETURN (answer);
     end "or";

     FUNCTION "nor"  ( arg1,arg2 : SIGNED ) RETURN SIGNED IS
       CONSTANT len : INTEGER := maximum(arg1'length,arg2'length) ;
       VARIABLE a,b : UNSIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
       VARIABLE answer : SIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
        -- Vector-wide NOR with sign extend 
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF arg2:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF answer:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF answer:VARIABLE IS "NOR" ; 
     BEGIN
       a := (OTHERS => arg1(arg1'left)) ;
       a(arg1'length - 1 DOWNTO 0) := UNSIGNED(arg1);
       b := (OTHERS => arg2(arg2'left)) ;
       b(arg2'length - 1 DOWNTO 0) := UNSIGNED(arg2);
       answer := SIGNED(a nor b);
       RETURN (answer);
     end "nor";

     FUNCTION "xnor"  ( arg1, arg2 : UNSIGNED ) RETURN UNSIGNED IS
         CONSTANT ml  : integer := maximum( arg1'LENGTH, arg2'LENGTH );
         VARIABLE lt  : UNSIGNED ( 1 to ml );
         VARIABLE rt  : UNSIGNED ( 1 to ml );
         VARIABLE res : UNSIGNED ( 1 to ml );
        -- Vector-wide XNOR with zero extend 
        ATTRIBUTE synthesis_return OF res:VARIABLE IS "XNOR" ; 
     begin
         lt := zxt( arg1, ml );
         rt := zxt( arg2, ml );
         FOR i IN res'RANGE LOOP
             res(i) := not_table( xor_table( lt(i), rt(i) ) );
         END LOOP;
         RETURN res;
     end "xnor";

     FUNCTION "xnor"  ( arg1, arg2 : SIGNED ) RETURN SIGNED IS
       CONSTANT len : INTEGER := maximum(arg1'length,arg2'length) ;
       VARIABLE a,b : UNSIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
       VARIABLE answer : SIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
        -- Vector-wide XNOR with sign extend 
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF arg2:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF answer:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF answer:VARIABLE IS "XNOR" ; 
     BEGIN
       a := (OTHERS => arg1(arg1'left)) ;
       a(arg1'length - 1 DOWNTO 0) := UNSIGNED(arg1);
       b := (OTHERS => arg2(arg2'left)) ;
       b(arg2'length - 1 DOWNTO 0) := UNSIGNED(arg2);
       answer := SIGNED(a xnor b);
       RETURN (answer);
     end "xnor";

    FUNCTION and_reduce(arg: SIGNED) RETURN STD_LOGIC IS
      VARIABLE result: STD_LOGIC;
      -- Exemplar synthesis directive attributes for this function
      ATTRIBUTE synthesis_RETURN OF result:VARIABLE IS "REDUCE_AND" ;
    BEGIN
      result := '1';
      FOR i IN arg'RANGE LOOP
        result := result AND arg(i);
      END LOOP;
      RETURN result;
    END;

    FUNCTION nand_reduce(arg: SIGNED) RETURN STD_LOGIC IS
      VARIABLE result: STD_LOGIC;
      ATTRIBUTE synthesis_RETURN OF result:VARIABLE IS "REDUCE_NAND" ;
    BEGIN
        result := NOT and_reduce(arg);
        RETURN result;
    END;

    FUNCTION and_reduce(arg: UNSIGNED) RETURN STD_LOGIC IS
      VARIABLE result: STD_LOGIC;
      -- Exemplar synthesis directive attributes for this function
      ATTRIBUTE synthesis_RETURN OF result:VARIABLE IS "REDUCE_AND" ;
    BEGIN
      result := '1';
      FOR i IN arg'RANGE LOOP
        result := result AND arg(i);
      END LOOP;
      RETURN result;
    END;

    FUNCTION nand_reduce(arg: UNSIGNED) RETURN STD_LOGIC IS
      VARIABLE result: STD_LOGIC;
      ATTRIBUTE synthesis_RETURN OF result:VARIABLE IS "REDUCE_NAND" ;
    BEGIN
        result := NOT and_reduce(arg);
        RETURN result;
    END;

      FUNCTION hasx( v : SIGNED ) RETURN BOOLEAN IS
         -- Synthesizable as is. Normal synthesis rules apply for
         -- comparison of metalogical values.
      BEGIN
         FOR i IN v'range LOOP
             IF v(i) = '0' OR v(i) = '1' OR v(i) = 'L' OR v(i) = 'H'THEN
                 NULL;
             ELSE
                 RETURN TRUE;
             END IF;
         END LOOP;
         RETURN FALSE;
      END hasx;

      FUNCTION hasx( v : UNSIGNED ) RETURN BOOLEAN IS
         -- Synthesizable as is. Normal synthesis rules apply for
         -- comparison of metalogical values.
      BEGIN
         FOR i IN v'range LOOP
             IF v(i) = '0' OR v(i) = '1' OR v(i) = 'L' OR v(i) = 'H'THEN
                 NULL;
             ELSE
                 RETURN TRUE;
             END IF;
         END LOOP;
         RETURN FALSE;
      END hasx;

    FUNCTION sxt( q : SIGNED; i : INTEGER ) RETURN SIGNED IS
        VARIABLE qs : SIGNED (1 TO i);
        VARIABLE qt : SIGNED (1 TO q'length);
        -- Hidden function for synthesis; Directives set for its callers
    BEGIN
        qt := q;
        IF i < q'length THEN
            qs := qt( (q'length-i+1) TO qt'right);
        ELSIF i > q'length THEN
            qs := (OTHERS=>q(q'left));
            qs := qs(1 TO (i-q'length)) & qt;
        ELSE
            qs := qt;
        END IF;
        RETURN qs;
    END;

  FUNCTION "abs" (arg1:SIGNED)  RETURN SIGNED IS
    constant    len      : integer := arg1'length;
    VARIABLE    answer, tmp   : SIGNED( len-1 downto 0 ) := (others=>'0');
    VARIABLE    index    : integer := len;
        -- Absolute value of Signed vector
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE ;
        -- Return a UNsigned vector that is abs of the input vector
        ATTRIBUTE synthesis_return OF answer:VARIABLE IS "ABS" ; 
  BEGIN
         assert arg1'length > 1
           report "SIGNED vector must be atleast 2 bits wide"
           severity ERROR;
    IF hasx(arg1) THEN
      answer := (OTHERS => 'X');
    ELSIF (arg1(arg1'left) = '0' OR arg1(arg1'left) = 'L') THEN
        answer := arg1;
    ELSE
      tmp := arg1;
      lp1 : FOR i IN answer'REVERSE_RANGE LOOP
         IF (tmp(i) = '1' OR tmp(i) = 'H') THEN
           index := i+1;
           answer(i downto 0) := tmp(i downto 0);
           exit;
         END IF;
       END LOOP lp1;
       answer(len-1 downto index) := NOT tmp(len-1 downto index);
     end if;
   RETURN (answer);
  END ;

  FUNCTION to_stdlogic (arg1:BOOLEAN)  RETURN STD_LOGIC IS
      -- Synthesizable as is.
      BEGIN
      IF(arg1) THEN
        RETURN('1') ;
      ELSE
        RETURN('0') ;
      END IF ;
  END ;

   FUNCTION maximum (arg1,arg2:INTEGER) RETURN INTEGER IS
     BEGIN
       IF(arg1 > arg2) THEN
         RETURN(arg1) ;
       ELSE
         RETURN(arg2) ;
       END IF;
   END ;

   FUNCTION minimum (arg1,arg2:INTEGER) RETURN INTEGER IS
     BEGIN
       IF(arg1 < arg2) THEN
         RETURN(arg1) ;
       ELSE
         RETURN(arg2) ;
       END IF;
   END ;

     FUNCTION "xor"  ( arg1, arg2 : UNSIGNED ) RETURN UNSIGNED IS
         CONSTANT ml  : integer := maximum( arg1'LENGTH, arg2'LENGTH );
         VARIABLE lt  : UNSIGNED ( 1 to ml );
         VARIABLE rt  : UNSIGNED ( 1 to ml );
         VARIABLE res : UNSIGNED ( 1 to ml );
        -- Vector-wide XOR with zero-extend
        ATTRIBUTE synthesis_return OF res:VARIABLE IS "XOR" ; 
     begin
         lt := zxt( arg1, ml );
         rt := zxt( arg2, ml );
         FOR i IN res'RANGE LOOP
             res(i) := xor_table( lt(i), rt(i) );
         END LOOP;
         RETURN res;
     end "xor";

     FUNCTION "xor"  ( arg1, arg2 : SIGNED ) RETURN SIGNED IS
       CONSTANT len : INTEGER := maximum(arg1'length,arg2'length) ;
       VARIABLE a,b : UNSIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
       VARIABLE answer : SIGNED(len-1 DOWNTO 0) := (OTHERS => '0') ;
        -- Vector-wide XOR with sign extend 
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF arg2:CONSTANT IS TRUE ;
        ATTRIBUTE is_signed OF answer:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF answer:VARIABLE IS "XOR" ; 
     BEGIN
       a := (OTHERS => arg1(arg1'left)) ;
       a(arg1'length - 1 DOWNTO 0) := UNSIGNED(arg1);
       b := (OTHERS => arg2(arg2'left)) ;
       b(arg2'length - 1 DOWNTO 0) := UNSIGNED(arg2);
       answer := SIGNED(a xor b);
       RETURN (answer);
     end "xor";

      FUNCTION shift( v : SIGNED ) RETURN SIGNED IS
         VARIABLE v1 : SIGNED( v'range );
         -- Hidden function. Synthesis directives set for its callers.
      BEGIN
         FOR i IN (v'left+1) TO v'right LOOP
             v1(i-1) := v(i);
         END LOOP;
         v1(v1'right) := '0';
         RETURN v1;
      END shift;

      FUNCTION shift( v : UNSIGNED ) RETURN UNSIGNED IS
         VARIABLE v1 : UNSIGNED( v'range );
         -- Hidden function. Synthesis directives set for its callers.
      BEGIN
         FOR i IN (v'left+1) TO v'right LOOP
             v1(i-1) := v(i);
         END LOOP;
         v1(v1'right) := '0';
         RETURN v1;
      END shift;

      FUNCTION rshift( v : UNSIGNED ) RETURN UNSIGNED IS
         VARIABLE v1 : UNSIGNED( v'range );
         -- Hidden function for synthesis; Directives set for its callers
      BEGIN
         FOR i IN v'left TO v'right-1 LOOP
             v1(i+1) := v(i);
         END LOOP;
         v1(v1'left) := '0';
         RETURN v1;
      END rshift;

      FUNCTION rshift( v : SIGNED ) RETURN SIGNED IS
         VARIABLE v1 : SIGNED( v'range );
         -- Hidden function for synthesis; Directives set for its callers
      BEGIN
         FOR i IN v'left TO v'right-1 LOOP
             v1(i+1) := v(i);
         END LOOP;
         v1(v1'left) := '0';
         RETURN v1;
      END rshift;

      FUNCTION "/" (l, r :UNSIGNED) RETURN UNSIGNED IS

        CONSTANT ml     : INTEGER := maximum(l'length,r'length);
        VARIABLE lt     : UNSIGNED(0 TO ml+1);
        VARIABLE rt     : UNSIGNED(0 TO ml+1);
        VARIABLE quote  : UNSIGNED(1 TO ml)   := (OTHERS=>'X');
        VARIABLE tmp    : UNSIGNED(0 TO ml+1) := (OTHERS=>'0');
        VARIABLE n      : UNSIGNED(0 TO ml+1) := (OTHERS=>'0');

        -- Division of Unsigned vectors.
        ATTRIBUTE synthesis_return OF quote:VARIABLE IS "DIV" ; 
      BEGIN
         if (eq(r,"0")) then
           ASSERT false
             REPORT "Attempted divide by ZERO"
             SEVERITY ERROR;
         ELSIF NOT (hasx(l) OR hasx(r)) THEN
           lt := zxt( l, ml+2 );
           WHILE lt >= r LOOP
             rt := zxt( r, ml+2 );
             n := (OTHERS=>'0');
             n(n'right) := '1';
             WHILE rt <= lt LOOP
               rt := shift(rt);
               n  := shift(n);
             END LOOP;
             rt := rshift(rt);
             lt := lt - rt;
             n := rshift(n);
             tmp := tmp + n;
           END LOOP;
           quote := tmp(2 TO ml+1);
         END IF;
         RETURN quote;
      END "/";

      FUNCTION "MOD" (l, r :UNSIGNED) RETURN UNSIGNED IS

        CONSTANT ml     : INTEGER := maximum(l'length,r'length);
        VARIABLE lt     : UNSIGNED(0 TO ml+1);
        VARIABLE rt     : UNSIGNED(0 TO ml+1);

        -- Modulo with unsigned vectors
        VARIABLE result : UNSIGNED(2 to ml+1)   := (OTHERS=>'X');
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "MOD" ; 
      BEGIN
         if (eq(r,"00")) then
           ASSERT false
             REPORT "Attempted divide by ZERO"
             SEVERITY ERROR;
         ELSIF NOT (hasx(l) OR hasx(r)) THEN
          lt := zxt( l, ml+2 );
          WHILE lt >= r LOOP
            rt := zxt( r, ml+2 );
            WHILE rt <= lt LOOP
              rt := shift(rt);
            END LOOP;
            rt := rshift(rt);
            lt := lt - rt;
          END LOOP;
          result := lt(2 TO ml+1);
        END IF;
        RETURN result ;
      END "MOD";

      FUNCTION "REM" (l, r :UNSIGNED) RETURN UNSIGNED IS

        CONSTANT ml     : INTEGER := maximum(l'length,r'length);
        VARIABLE lt     : UNSIGNED(0 TO ml+1);
        VARIABLE rt     : UNSIGNED(0 TO ml+1);

        -- Remainder with unsigned vectors
        VARIABLE result : UNSIGNED(2 to ml+1)   := (OTHERS=>'X');
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "REM" ; 
      BEGIN
         if (eq(r,"0")) then
           ASSERT false
             REPORT "Attempted divide by ZERO"
             SEVERITY ERROR;
         ELSIF NOT (hasx(l) OR hasx(r)) THEN
          lt := zxt( l, ml+2 );
          WHILE lt >= r LOOP
            rt := zxt( r, ml+2 );
            WHILE rt <= lt LOOP
              rt := shift(rt);
            END LOOP;
            rt := rshift(rt);
            lt := lt - rt;
          END LOOP;
          result := lt(2 TO ml+1);
        END IF;
        RETURN result ;
      END "REM";

      FUNCTION "**" (l, r :UNSIGNED) RETURN UNSIGNED IS

        VARIABLE return_vector : UNSIGNED(l'range) := (OTHERS=>'0');
        VARIABLE tmp           : UNSIGNED(1 TO (2 * l'length)) := (OTHERS=>'0');
        CONSTANT lsh_l         : INTEGER := l'length+1;
        CONSTANT lsh_r         : INTEGER := 2 * l'length;
        VARIABLE pow           : INTEGER;

        -- Power with unsigned vectors
        ATTRIBUTE synthesis_return OF return_vector:VARIABLE IS "POWER" ; 
      BEGIN
         IF (hasx(l) OR hasx(r)) THEN
             FOR i IN return_vector'range LOOP
                 return_vector(i) := 'X';
             END LOOP;
         ELSE
             pow := conv_integer(r);
             tmp( tmp'right ) := '1';
             FOR i IN 1 TO pow LOOP
                 tmp := tmp(lsh_l TO lsh_r) * l;
             END LOOP;
             return_vector := tmp(lsh_l TO lsh_r);
         END IF;
         RETURN return_vector;
      END "**";

      FUNCTION "**" (l, r :SIGNED) RETURN SIGNED IS

        VARIABLE return_vector : SIGNED(l'range) := (OTHERS=>'0');
        VARIABLE tmp           : SIGNED(1 TO (2 * l'length)) := (OTHERS=>'0');
        CONSTANT lsh_l         : INTEGER := l'length+1;
        CONSTANT lsh_r         : INTEGER := 2 * l'length;
        VARIABLE pow           : INTEGER;

        -- Power with signed vectors
        ATTRIBUTE is_signed OF l:CONSTANT IS TRUE;
        ATTRIBUTE is_signed OF r:CONSTANT IS TRUE;
        -- Return a signed vector that is power of the input vectors
        ATTRIBUTE is_signed OF return_vector:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF return_vector:VARIABLE IS "POWER" ; 
      BEGIN
         IF (hasx(l) OR hasx(r)) THEN
             FOR i IN return_vector'range LOOP
                 return_vector(i) := 'X';
             END LOOP;
         ELSE
             pow := conv_integer(r);
             tmp( tmp'right ) := '1';
             FOR i IN 1 TO pow LOOP
                 tmp := tmp(lsh_l TO lsh_r) * l;
             END LOOP;
             return_vector := tmp(lsh_l TO lsh_r);
         END IF;
         RETURN return_vector;
      END "**";

--
-- Shift Left (arithmetic) Functions
--

  FUNCTION "sla" (arg1:UNSIGNED ; arg2:NATURAL)  RETURN UNSIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT se : UNSIGNED(1 to len) := (others => arg1(arg1'right));
     VARIABLE ans : UNSIGNED(1 to len) := arg1;
        -- VHDL 93 SLA 
        VARIABLE result : UNSIGNED (1 to len) ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "SLA" ; 
  BEGIN
    IF (arg2 >= len) THEN
      ASSERT FALSE
        REPORT "shift is further than array size."
        SEVERITY WARNING ;
      result := se;
    ELSIF (arg2 = 0) THEN
      result := arg1;
    ELSE
      result := ans(arg2+1 to len) & se(1 to arg2);
    END IF;
    RETURN result ;
  END ;

  FUNCTION "sla" (arg1:SIGNED   ; arg2:NATURAL)  RETURN SIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT se : SIGNED(1 to len) := (others => arg1(arg1'right));
     VARIABLE ans : SIGNED(1 to len) := arg1;
        -- VHDL 93 SLA 
        VARIABLE result : SIGNED (1 to len) ;
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE;
        ATTRIBUTE is_signed OF result:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "SLA" ; 
  BEGIN
    IF (arg2 >= len) THEN
      ASSERT FALSE
        REPORT "shift is further than array size."
        SEVERITY WARNING ;
      result := se;
    ELSIF (arg2 = 0) THEN
      result := arg1;
    ELSE
      result := ans(arg2+1 to len) & se(1 to arg2);
    END IF;
    RETURN result ;
  END ;

--
-- Shift Right (arithmetics) Functions
--
  FUNCTION "sra" (arg1:UNSIGNED ; arg2:NATURAL)  RETURN UNSIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT se : UNSIGNED(1 to len) := (others => arg1(arg1'left));
     VARIABLE ans : UNSIGNED(1 to len) := arg1;
        -- VHDL 93 SRA 
        VARIABLE result : UNSIGNED (1 to len) ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "SRA" ; 
  BEGIN
    IF (arg2 >= len) THEN
      ASSERT FALSE
        REPORT "shift is further than array size."
        SEVERITY WARNING ;
      result := (se);
    ELSIF (arg2 = 0) THEN
      result := (arg1);
    ELSE
      result := (se(1 to arg2) & ans(1 to len-arg2));
    END IF;
    RETURN result ;
  END ;

  FUNCTION "sra" (arg1:SIGNED   ; arg2:NATURAL)  RETURN SIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT se : SIGNED(1 to len) := (others => arg1(arg1'left));
     VARIABLE ans : SIGNED(1 to len) := arg1;
        -- VHDL 93 SRA 
        VARIABLE result : SIGNED (1 to len) ;
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE;
        ATTRIBUTE is_signed OF result:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "SRA" ; 
  BEGIN
    IF (arg2 >= len) THEN
      ASSERT FALSE
        REPORT "shift is further than array size."
        SEVERITY WARNING ;
      result := (se);
    ELSIF (arg2 = 0) THEN
      result := (arg1);
    ELSE
      result := (se(1 to arg2) & ans(1 to len-arg2));
    END IF;
    RETURN result ;
  END ;

--
-- Shift Left (logical) Functions
--
  FUNCTION "sll" (arg1:UNSIGNED ; arg2:NATURAL)  RETURN UNSIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT se : UNSIGNED(1 to len) := (others =>'0');
     VARIABLE ans : UNSIGNED(1 to len) := arg1;
        -- VHDL 93 SLL 
        VARIABLE result : UNSIGNED (1 to len) ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "SLL" ; 
  BEGIN
    IF (arg2 >= len) THEN
      ASSERT FALSE
        REPORT "shift is further than array size."
        SEVERITY WARNING ;
      result := (se);
    ELSIF (arg2 = 0) THEN
      result := (arg1);
    ELSE
      result := (ans(arg2+1 to len) & se(1 to arg2));
    END IF;
    RETURN result ;
  END ;

  FUNCTION "sll" (arg1:SIGNED   ; arg2:NATURAL)  RETURN SIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT se : SIGNED(1 to len) := (others =>'0');
     VARIABLE ans : SIGNED(1 to len) := arg1;
        -- VHDL 93 SLL 
        VARIABLE result : SIGNED (1 to len) ;
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE;
        ATTRIBUTE is_signed OF result:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "SLL" ; 
  BEGIN
    IF (arg2 >= len) THEN
      ASSERT FALSE
        REPORT "shift is further than array size."
        SEVERITY WARNING ;
      result := (se);
    ELSIF (arg2 = 0) THEN
      result := (arg1);
    ELSE
      result := (ans(arg2+1 to len) & se(1 to arg2));
    END IF;
    RETURN result ;
  END ;

--
-- Shift Right (logical) Functions
--
  FUNCTION "srl" (arg1:UNSIGNED ; arg2:NATURAL)  RETURN UNSIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT se : UNSIGNED(1 to len) := (others => '0');
     VARIABLE ans : UNSIGNED(1 to len) := arg1;
        -- VHDL 93 SRL 
        VARIABLE result : UNSIGNED (1 to len) ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "SRL" ; 
  BEGIN
    IF (arg2 >= len) THEN
      ASSERT FALSE
        REPORT "shift is further than array size."
        SEVERITY WARNING ;
      result := (se);
    ELSIF (arg2 = 0) THEN
      result := (arg1);
    ELSE
      result := (se(1 to arg2) & ans(1 to len-arg2));
    END IF;
    RETURN result ;
  END ;

  FUNCTION "srl" (arg1:SIGNED   ; arg2:NATURAL)  RETURN SIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT se : SIGNED(1 to len) := (others => '0');
     VARIABLE ans : SIGNED(1 to len) := arg1;
        -- VHDL 93 SRL 
        VARIABLE result : SIGNED (1 to len) ;
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE;
        ATTRIBUTE is_signed OF result:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "SRL" ; 
  BEGIN
    IF (arg2 >= len) THEN
      ASSERT FALSE
        REPORT "shift is further than array size."
        SEVERITY WARNING ;
      result := (se);
    ELSIF (arg2 = 0) THEN
      result := (arg1);
    ELSE
      result := (se(1 to arg2) & ans(1 to len-arg2));
    END IF;
    RETURN result ;
  END ;

--
-- Rotate Left (Logical) Functions
--
  FUNCTION "rol" (arg1:UNSIGNED ; arg2:NATURAL)  RETURN UNSIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT marg2 : integer := arg2 mod len;
     VARIABLE ans : UNSIGNED(1 to len) := arg1;
        -- VHDL 93 ROL 
        VARIABLE result : UNSIGNED (1 to len) ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "ROL" ; 
  BEGIN
    ASSERT arg2 <= len
      REPORT "rotate is further than array size."
      SEVERITY WARNING ;
    IF (marg2 = 0) THEN
      result := (arg1);
    ELSE
      result := (ans(marg2+1 to len) & ans(1 to marg2));
    END IF;
    RETURN result ;
  END ;

  FUNCTION "rol" (arg1:SIGNED   ; arg2:NATURAL)  RETURN SIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT marg2 : integer := arg2 mod len;
     VARIABLE ans : SIGNED(1 to len) := arg1;
        -- VHDL 93 ROL 
        VARIABLE result : SIGNED (1 to len) ;
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE;
        ATTRIBUTE is_signed OF result:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "ROL" ; 
  BEGIN
    ASSERT arg2 <= len
      REPORT "rotate is further than array size."
      SEVERITY WARNING ;
    IF (marg2 = 0) THEN
      result := (arg1);
    ELSE
      result := (ans(marg2+1 to len) & ans(1 to marg2));
    END IF;
    RETURN result ;
  END ;

--
-- Rotate Right (Logical) Functions
--
  FUNCTION "ror" (arg1:UNSIGNED ; arg2:NATURAL)  RETURN UNSIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT marg2 : integer := arg2 mod len;
     VARIABLE ans : UNSIGNED(1 to len) := arg1;
        -- VHDL 93 ROR 
        VARIABLE result : UNSIGNED (1 to len) ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "ROR" ; 
  BEGIN
    ASSERT arg2 <= len
      REPORT "rotate is further than array size."
      SEVERITY WARNING ;
    IF (marg2 = 0) THEN
      result := (arg1);
    ELSE
      result := (ans(len-marg2+1 to len) & ans(1 to len-marg2));
    END IF;
    RETURN result ;
  END ;

  FUNCTION "ror" (arg1:SIGNED   ; arg2:NATURAL)  RETURN SIGNED IS
     CONSTANT len : INTEGER := arg1'length ;
     CONSTANT marg2 : integer := arg2 mod len;
     VARIABLE ans : SIGNED(1 to len) := arg1;
        -- VHDL 93 ROR 
        VARIABLE result : SIGNED (1 to len) ;
        ATTRIBUTE is_signed OF arg1:CONSTANT IS TRUE;
        ATTRIBUTE is_signed OF result:VARIABLE IS TRUE ;
        ATTRIBUTE synthesis_return OF result:VARIABLE IS "ROR" ; 
  BEGIN
    ASSERT arg2 <= len
      REPORT "rotate is further than array size."
      SEVERITY WARNING ;
    IF (marg2 = 0) THEN
      result := (arg1);
    ELSE
      result := (ans(len-marg2+1 to len) & ans(1 to len-marg2));
    END IF;
    RETURN result ;
  END ;

--
-- In general, objects in this package are required to be functions.
-- For synthesizability reasons, we want the "flipflop" functions to be
-- procedures.  There is a special kludge in the rtl netlister to let
-- this work.
--

   procedure flipflop
     (signal input : in std_logic;
      signal clk : in std_logic;
      signal output : out std_logic) is
      attribute SYNTHESIS_RETURN of output:signal is "flipflop";
   begin
     if (clk'last_value = '0' and clk = '1') then
       output <= input;
     end if;
   end;
   
   procedure flipflop
     (signal input : in unsigned;
      signal clk : in std_logic;
      signal output : out unsigned) is
      attribute SYNTHESIS_RETURN of output:signal is "flipflop";
   begin
     if (clk'last_value = '0' and clk = '1') then
       output <= input;
     end if;
   end;
   
   procedure flipflop
     (signal input : in std_logic;
      signal clk : in std_logic;
      signal output : out std_logic;
      signal rst : in std_logic;
      signal value : in std_logic) is
      attribute SYNTHESIS_RETURN of output:signal is "flipflop";
   begin
     if (rst = '1') then
       output <= value;
     elsif (clk'event and clk = '1') then
       output <= input;
     end if;
   end;
   
   procedure flipflop
     (signal input : in unsigned;
      signal clk : in std_logic;
      signal output : out unsigned;
      signal rst : in std_logic;
      signal value : in unsigned) is
      attribute SYNTHESIS_RETURN of output:signal is "flipflop";
   begin
     if (rst = '1') then
       output <= value;
     elsif (clk'event and clk = '1') then
       output <= input;
     end if;
   end;

--
-- This is used in the special case when we need to pick a vector that
-- has been changed into a constant.  This is because the VHDL language
-- doesn't allow one to say "bits"[index]
--
   
   function readindex
     (input : unsigned;
      index : natural) return std_logic is
      variable result : std_logic;
      attribute SYNTHESIS_RETURN of result:variable is "readindex";
   begin
     result := input(index);
     return result;
   end;

--
-- The following procedures insert n consecutive wait until edge
-- statements into the process. 'phase' gives the active edge ie it
-- should be either '1' or '0'
--
 
   procedure wait_clock_cycles
     (constant n : natural;
      signal clk : in std_logic;
      constant phase : in std_logic) is
      -- pragma built_in synch
   begin
       for i in 1 to n loop
         wait until clk'event and clk=phase;
       end loop;
   end;
 
   procedure wait_clock_cycles
     (constant n : natural;
      signal clk : in bit;
      constant phase : in bit) is
      -- pragma built_in synch
   begin
       for i in 1 to n loop
         wait until clk'event and clk=phase;
       end loop;
   end;

end FUNCS;
