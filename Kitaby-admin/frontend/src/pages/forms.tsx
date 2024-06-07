import { mdiAccount, mdiBallotOutline, mdiGithub, mdiMail, mdiUpload } from '@mdi/js'
import { Field, Form, Formik } from 'formik'
import Head from 'next/head'
import { ReactElement, use, useEffect, useState } from 'react'
import Button from '../components/Button'
import Buttons from '../components/Buttons'
import Divider from '../components/Divider'
import CardBox from '../components/CardBox'
import FormCheckRadio from '../components/Form/CheckRadio'
import FormCheckRadioGroup from '../components/Form/CheckRadioGroup'
import FormField from '../components/Form/Field'
import FormFilePicker from '../components/Form/FilePicker'
import LayoutAuthenticated from '../layouts/Authenticated'
import SectionMain from '../components/Section/Main'
import SectionTitle from '../components/Section/Title'
import SectionTitleLineWithButton from '../components/Section/TitleLineWithButton'
import { getPageTitle } from '../config'
import TableSampleClients from '../components/Table/SampleClients'
import TableSamplebooks from '../components/Table/SampleBooks'
import { set } from 'mongoose'

const FormsPage = () => {
  const [bookInfo, setBookInfo] = useState(null)
  const [title, setTitle] = useState(null)
  useEffect(() => {
    const fetchData = async (title) => {
      try {
        const response = await fetch(`http://localhost:3000/api/admin/getbookInfo/${title}`, {
          method: 'GET',
          headers: { 'Content-Type': 'application/json' },
        })
        const data = await response.json() // Extract JSON data from response
        setBookInfo(data) // Update state with fetched book info
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
    <div className="mx-5">
      <Head>
        <title>{getPageTitle('Forms')}</title>
      </Head>

      <SectionMain>
        <SectionTitleLineWithButton
          icon={mdiBallotOutline}
          title="Books"
          main
        ></SectionTitleLineWithButton>
      </SectionMain>
      <CardBox hasTable>
        <TableSamplebooks />
      </CardBox>

      <SectionTitleLineWithButton icon={mdiBallotOutline} title="Search Book Informations" main />
      {/*We will have a search bar that interacts with the api, it send the book name and the api returns the book informations */}
      <Formik initialValues={{ bookName: '' }} onSubmit={handleSearch}>
        <Form>
          <Field name="bookName" type="text" className="rounded-xl mx-4" />
          <button type="submit">Search</button>
        </Form>
      </Formik>

      <div className="h-auto p-4 bg-white dark:bg-gray-800 rounded shadow">
  {bookInfo && (
    <div className="space-y-2">
      <h2 className="text-xl font-bold text-gray-800">Book Information</h2>
      <p className="text-gray-700">
        <span className="font-semibold">Title:</span> {bookInfo.title}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">Author:</span> {bookInfo.author}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">ISBN:</span> {bookInfo.isbn}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">Bib owners:</span> {bookInfo.bibOwners}
      </p>
      <p className="text-gray-700">
        <span className="font-semibold">Owners:</span> {bookInfo.owners ? bookInfo.owners.map(owner => <span key={owner}>{owner}, </span>) : "None"}
      </p>
    </div>
  )}
</div>

      <div className='h-24'></div>
    </div>
  )
}

FormsPage.getLayout = function getLayout(page: ReactElement) {
  return <LayoutAuthenticated>{page}</LayoutAuthenticated>
}

export default FormsPage
