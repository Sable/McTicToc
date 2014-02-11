PROGRAM run
USE mod_{{##benchmark##}}
IMPLICIT NONE
DOUBLE PRECISION :: scale, time
INTEGER(KIND=4) :: int_tmpvar
CHARACTER(10) :: arg_buffer, correctness

int_tmpvar = 0
arg_buffer = '0000000000'
DO int_tmpvar = 1, IARGC()
   CALL GETARG(int_tmpvar, arg_buffer)
   IF ((int_tmpvar == 1)) THEN
      READ(arg_buffer, *) scale
   END IF
END DO

!
! Driver for adaptive quadrature using Simpson's rule.
!

CALL {{##benchmark##}}(scale, time, correctness);

print '("<json>{""time"":", f8.3, "")', time;
print *, ', "correct": ', correctness;
print *, '}</json>';

END PROGRAM
