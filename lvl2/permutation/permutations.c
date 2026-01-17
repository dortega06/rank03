/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   permutations.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: dortega- <dortega-@student.42barcelon      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/01/17 17:27:24 by dortega-          #+#    #+#             */
/*   Updated: 2026/01/17 17:38:51 by dortega-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

void	ft_swap(char *a, char *b)
{
	char tmp = *a;
	*a = *b;
	*b = tmp;
}

int	ft_strlen(char *str)
{
	int	i = 0;
	while (str[i])
		i++;
	return (i);
}

void ft_sort(char *s)
{
	int i = 0;
	int j;
	while(s[i])
	{
		j = 0;
		while(s[j + 1])
		{
			if(s[j] > s[j + 1])
				ft_swap(&s[j], &s[j + 1]);
			j++;
		}
		i++;
	}
}

void	perm(char *s, int l, int r)
{
	if(l == r)
	{
		puts(s);
		return ;
	}
	ft_sort(s + l);
	for(int i = l; i <= r; i++)
	{
		ft_swap(&s[l], &s[i]);
		perm(s, l + 1, r);
		ft_swap(&s[l], &s[i]);
	}
}

int	main(int argc, char **argv)
{
	if (argc != 2 || !argv[1][0])
		return (1);
	if (argc == 2)
	{
		int len = ft_strlen(argv[1]);
		perm(argv[1], 0, len - 1);
	}
	return (0);
}
