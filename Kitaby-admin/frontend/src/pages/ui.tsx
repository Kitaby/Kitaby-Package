import { mdiBallotOutline, mdiGithub, mdiMonitorCellphone, mdiTableBorder, mdiTableOff } from '@mdi/js'
import Head from 'next/head'
import React, { ReactElement,useEffect,useState } from 'react'
import Button from '../components/Button'
import CardBox from '../components/CardBox'
import CardBoxComponentEmpty from '../components/CardBox/Component/Empty'
import LayoutAuthenticated from '../layouts/Authenticated'
import NotificationBar from '../components/NotificationBar'
import SectionMain from '../components/Section/Main'
import SectionTitleLineWithButton from '../components/Section/TitleLineWithButton'
import TableSampleClients from '../components/Table/SampleClients'
import { getPageTitle } from '../config'
import TableSampleBibs from '../components/Table/SampleLibraries'
import { Field, Form, Formik } from 'formik'
const TablesPage = () => {
  const [bibInfo, setBibInfo] = useState(null)
  const [title, setTitle] = useState(null)
  useEffect(() => {
    const fetchData = async (title) => {
      try {
        const response = await fetch(`http://localhost:3000/api/admin/getbibInfo/${title}`, {
          method: 'GET',
          headers: { 'Content-Type': 'application/json' },
        })
        const data = await response.json() // Extract JSON data from response
        setBibInfo(data) // Update state with fetched book info
      } catch (error) {
        console.error('Error fetching data:', error)
      }
    }

    // Fetch data when title changes
    fetchData(title)
  }, [title])
  const handleSearch = (values) => {
    setTitle(values.bookName)
  }


  return (
    <div>
      <Head>
        <title>{getPageTitle('Tables')}</title>
      </Head>
      
        <SectionTitleLineWithButton icon={mdiTableBorder} title="Tables" main>
          
        </SectionTitleLineWithButton>

        

        <CardBox className="mb-6" hasTable>
          <TableSampleBibs/>
        </CardBox>

        <SectionTitleLineWithButton icon={mdiBallotOutline} title="Search Bib Informations" main />
      {/*We will have a search bar that interacts with the api, it send the book name and the api returns the book informations */}
      <Formik initialValues={{ bibName: '' }} onSubmit={handleSearch}>
        <Form>
          <Field name="bookName" type="text" className="rounded-xl mx-4" />
          <button type="submit">Search</button>
        </Form>
      </Formik>

        <div className="h-auto p-4 bg-white dark:bg-gray-800 rounded shadow">
  {bibInfo && (
    <div className="space-y-2">
      <h2 className="text-xl font-bold text-gray-800">Bib Information</h2>
      <p className="text-gray-700">
        <span className="font-semibold">Title:</span> {bibInfo.name}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">Wilaya: </span> {bibInfo.wilaya}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">Address: </span> {bibInfo.address}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">Opening Hours:</span> {bibInfo.openingHours ? bibInfo.openingHours : '9:00 AM - 5:00 PM'}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">Bib reservations IDs:</span> {bibInfo.reservations.map(reservation => <span key={reservation}>{reservation}, </span>)}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">Available Books:</span> {bibInfo.avalaibleBooks.map(book => <span key={book}>{book}, </span>)}
      </p>
      
    </div>
  )}
</div>
    </div>
  )
}

TablesPage.getLayout = function getLayout(page: ReactElement) {
  return <LayoutAuthenticated>{page}</LayoutAuthenticated>
}

export default TablesPage
