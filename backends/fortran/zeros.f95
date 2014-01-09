MODULE mod_zeros
INTERFACE zeros
MODULE PROCEDURE zeros_1, zeros_2, zeros_2DI, zeros_3 ! may be more
END INTERFACE zeros

CONTAINS

FUNCTION zeros_1(x)
IMPLICIT NONE
DOUBLE PRECISION, INTENT(IN) :: x
DOUBLE PRECISION, DIMENSION(INT(x),INT(x)) :: zeros_1
END FUNCTION zeros_1

FUNCTION zeros_2(x,y)
IMPLICIT NONE
DOUBLE PRECISION, INTENT(IN) :: x, y
DOUBLE PRECISION, DIMENSION(INT(x),INT(y)) :: zeros_2
END FUNCTION zeros_2

FUNCTION zeros_2DI(x,y)
IMPLICIT NONE
DOUBLE PRECISION, INTENT(IN) :: x
INTEGER, INTENT(IN) :: y
DOUBLE PRECISION, DIMENSION(INT(x),y) :: zeros_2DI
END FUNCTION zeros_2DI

FUNCTION zeros_3(x,y,z)
IMPLICIT NONE
DOUBLE PRECISION, INTENT(IN) :: x, y, z
DOUBLE PRECISION, DIMENSION(INT(x),INT(y),INT(z)) :: zeros_3
END FUNCTION zeros_3

END MODULE mod_zeros

