
const book_categories=async(isbn)=>{
    const url="https://openlibrary.org/search.json?isbn="+isbn+"&fields=subject"
    try {
        const response=await fetch(url)
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const data = await response.json();
        return data.docs[0].subject.slice(0,5);

    } catch (error) {
        console.error('Error fetching data:', error);
        throw error; 

    }

}

module.exports=book_categories