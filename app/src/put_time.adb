with Ada.Text_IO;
with Interfaces.C; use Interfaces.C;

with arch_arm_aarch32_misc_h; use arch_arm_aarch32_misc_h;

procedure Put_Time is
   Current_Time : unsigned;
begin
   Current_Time := z_timer_cycle_get_32;

   Ada.Text_IO.Put("[" & unsigned'Image(Current_Time) & "] ");
end Put_Time;