import { mdiGithub, mdiMonitorCellphone, mdiTableBorder, mdiTableOff } from '@mdi/js'
import Head from 'next/head'
import React, { ReactElement, useState,useEffect} from 'react'
import Button from '../components/Button'
import CardBox from '../components/CardBox'
import CardBoxComponentEmpty from '../components/CardBox/Component/Empty'
import LayoutAuthenticated from '../layouts/Authenticated'
import NotificationBar from '../components/NotificationBar'
import SectionMain from '../components/Section/Main'
import SectionTitleLineWithButton from '../components/Section/TitleLineWithButton'
import TableSampleClients from '../components/Table/SampleClients'
import { getPageTitle } from '../config'
import { Field, Form, Formik } from 'formik'
const TablesPage = () => {
  const [userInfo, setUserInfo] = useState(null)
  const [name, setName] = useState(null)
  useEffect(() => {
    const fetchData = async (name) => {
      try {
        const response = await fetch(`http://localhost:3000/api/admin/getuserinfo/${name}`, {
          method: 'GET',
          headers: { 'Content-Type': 'application/json' },
        })
        const data = await response.json() // Extract JSON data from response
        setUserInfo(data) // Update state with fetched book info
      } catch (error) {
        console.error('Error fetching data:', error)
      }
    }

    // Fetch data when title changes
    fetchData(name)
  }, [name])
  const handleSearch = (values) => {
    setName(values.userName)
  }

  return (
    <>
      <Head>
        <title>{getPageTitle('Tables')}</title>
      </Head>
      <SectionMain>
        <SectionTitleLineWithButton icon={mdiTableBorder} title="Tables" main>
          
        </SectionTitleLineWithButton>

        

        <CardBox className="mb-6" hasTable>
          <TableSampleClients />
        </CardBox>

        {/* <SectionTitleLineWithButton icon={mdiTableOff} title="Empty variation" /> */}

        

        {/* <CardBox>
          <CardBoxComponentEmpty />
        </CardBox> */}
      </SectionMain>
      <Formik initialValues={{ bibName: '' }} onSubmit={handleSearch}>
        <Form>
          <Field name="userName" type="text" className="rounded-xl mx-4" />
          <button type="submit">Search</button>
        </Form>
      </Formik>
      <div className="h-auto p-4 bg-white dark:bg-gray-800 rounded shadow">
  {userInfo && (
    <div className="space-y-2">
      <h2 className="text-xl font-bold text-gray-800">User Information</h2>
      <p className="text-gray-700">
        <span className="font-semibold">name:</span> {userInfo.name}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">wilaya:</span> {userInfo.wilaya}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">phone number:</span> {userInfo.phone}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">User owned books :</span> {userInfo.ownedBooks.map(book => <span key={book}>{book}, </span>)}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">User wishlist books: </span> {userInfo.wishlist.map(book => <span key={book}>{book}, </span>)}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">User reservations: </span> {userInfo.reservations.map(reservation => <span key={reservation}>{reservation}, </span>)}
      </p>
      
      
    </div>
  )}
</div>
    </>
  )
}

TablesPage.getLayout = function getLayout(page: ReactElement) {
  return <LayoutAuthenticated>{page}</LayoutAuthenticated>
}

export default TablesPage
