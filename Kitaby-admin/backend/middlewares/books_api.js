
const book_api = async (isbn) => {
    try {
        const url='https://www.googleapis.com/books/v1/volumes?q=isbn:'+isbn
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error fetching data:', error);
        throw error; 
    }
};

module.exports=book_api