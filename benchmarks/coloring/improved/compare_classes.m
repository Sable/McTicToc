function res = compare_classes(aid, bid)
%
% Compare two classes in an arbitrary total order.
%
% This function is used to sort classes of a list in an arbitrary linear extension:
% 	if a is_subtype_of b return 1
% 	if a is_supertype_of b return -1
% 	else result is based on the comparison of indexes
%		 so the total order is stable unless the indexes are changed.
%

global matrix;

supa = matrix(aid, :);
supb = matrix(bid, :);
lena = length(nonzeros(supa));
lenb = length(nonzeros(supb));

if matrix(aid, bid) == 1
	res = 1;
elseif matrix(bid, aid) == 1
	res = -1;
else
	if lena < lenb
		res = -1;
	elseif lena > lenb
		res = 1;
	else
		if aid < bid
			res = -1;
		elseif aid > bid
			res = 1;
		else
			res = 0;
		end
	end
end

end

