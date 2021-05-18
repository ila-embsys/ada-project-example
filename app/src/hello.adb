with Ada.Text_IO;
with Put_Time;

with stdint_h; use stdint_h; 
with generated_syscalls_kernel_h; use generated_syscalls_kernel_h;

procedure Hello is
   ret: int32_t;
begin
   loop
      Put_Time;
      Ada.Text_IO.Put_Line("Hello, world! It's Ada!");

      ret := z_impl_k_usleep(200000);
   end loop;
end Hello;
