

//import useSWR from 'swr';
import { User } from '../interfaces';

/* const fetcher = async (url: string): Promise<User> => {
  const res = await fetch(url);
  return res.json();
}; */
export async function useSampleClients(){
  /* try {
    const response = await fetch('http://localhost:3000/api/admin/getusers', {
      method: 'GET',
      headers: { 'Content-Type': 'application/json'}
    });

    if (!response.ok) {
      throw new Error('Failed to fetch data');
    }

    const data = await response.json();
    console.log(data);

    return data;
  } catch (error) {
    console.error('Error fetching data:', error);
    return null; // or handle the error in some other way
  } */
};


/* export const useSampleTransactions = () => {
  const { data, error } = useSWR('http://localhost:3000/transactions', fetcher); // Update the URL here

  return {
    transactions: data?.data ?? [],
    isLoading: !error && !data,
    isError: error,
  };
}; */